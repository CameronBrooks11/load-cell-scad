"""Render every load cell and amplifier board and check them.

usage: python3 tests/test_parts.py [OPENSCAD]

For each load cell it checks that it renders as one piece the size of its
bar plus the two gauges; that every mounting hole and both bores go right
through at their stated diameter (a pin 0.05 mm under size passes, one
0.2 mm over doesn't), and so do any slot and side notches; that each hole keeps at least 1 mm of metal to the
bar's end, its sides and the bores; and that the gauges cover the bending
section. For each amplifier board it checks its size, that it renders as
the board plus one loose pin per header position, that every pin passes
through its hole without touching, and that the mounting holes go through
at their stated diameter.
"""

import json
import os
import re
import struct
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROBE = os.path.join(ROOT, "tests", "probe.scad")


def run(openscad, out, defines, export="binstl"):
    cmd = [openscad, "--hardwarnings", "--export-format", export, "-o", out]
    for name, value in defines.items():
        cmd += ["-D", f"{name}={value}"]
    return subprocess.run(cmd + [PROBE], capture_output=True, text=True)


def mesh(path):
    data = open(path, "rb").read()
    (n,) = struct.unpack_from("<I", data, 80)
    return [struct.unpack_from("<9f", data, 84 + i * 50 + 12) for i in range(n)]


def volume(path):
    v = 0.0
    for a in mesh(path):
        p, q, r = a[0:3], a[3:6], a[6:9]
        v += (p[0] * (q[1] * r[2] - q[2] * r[1]) - p[1] * (q[0] * r[2] - q[2] * r[0])
              + p[2] * (q[0] * r[1] - q[1] * r[0])) / 6
    return abs(v)


def solids_and_size(path):
    parent = {}

    def find(v):
        while parent[v] != v:
            parent[v] = parent[parent[v]]
            v = parent[v]
        return v

    for a in mesh(path):
        corners = [a[0:3], a[3:6], a[6:9]]
        for c in corners:
            parent.setdefault(c, c)
        root = find(corners[0])
        for c in corners[1:]:
            parent[find(c)] = root
    size = [max(p[i] for p in parent) - min(p[i] for p in parent) for i in range(3)]
    return len({find(v) for v in parent}), size


def main():
    openscad = sys.argv[1] if len(sys.argv) > 1 else "openscad"
    failures = []

    def report(label, ok, got):
        print(f"{'ok  ' if ok else 'FAIL'} {label}: {got}")
        if not ok:
            failures.append(label)

    with tempfile.TemporaryDirectory() as tmp:
        stl = os.path.join(tmp, "case.stl")

        # Parts that overlap by more than 0.001 cu mm count as touching.
        def touches(**defines):
            result = run(openscad, stl, defines)
            if "top level object is empty" in result.stderr.lower():
                return False
            if result.returncode != 0:
                raise RuntimeError(result.stderr.strip().splitlines()[-1])
            return volume(stl) > 0.001

        echo = os.path.join(tmp, "rows.echo")
        run(openscad, echo, {"CHECK": '"rows"'}, export="echo")
        text = open(echo).read()
        rows = lambda key: [json.loads(m.replace("undef", "null")) for m in re.findall(rf"ECHO: {key} = (.*)", text)]
        cells, boards = rows("LC"), rows("AMP")
        report("every row is read", len(cells) == 5 and len(boards) == 2, f"{len(cells)} load cells, {len(boards)} boards")

        for i, (name, size, gauge, bores, holes, notches) in enumerate(cells):
            result = run(openscad, stl, {"CHECK": '"cell"', "INDEX": i})
            n, got = solids_and_size(stl) if result.returncode == 0 else (0, [0, 0, 0])
            want = [size[0], size[1], size[2] + 2 * gauge[2]]
            report(f"{name}: one piece, " + " x ".join(f"{v:g}" for v in want),
                   n == 1 and all(abs(a - b) < 0.01 for a, b in zip(got, want)),
                   f"{n} pieces, " + " x ".join(f"{v:.2f}" for v in got))

            for check, what in (("holes", "mounting holes"), ("bores", "bores")):
                through = not touches(CHECK=f'"{check}"', INDEX=i, GROW=-0.05)
                sized = touches(CHECK=f'"{check}"', INDEX=i, GROW=0.2)
                report(f"{name}: the {what} go through at their diameter", through and sized,
                       f"under-size pin {'passes' if through else 'blocked'}, over-size {'blocked' if sized else 'passes'}")

            if len(bores) > 3:
                through = not touches(CHECK='"slot"', INDEX=i, GROW=-0.05)
                sized = touches(CHECK='"slot"', INDEX=i, GROW=0.2)
                report(f"{name}: the slot joins the bores at its height", through and sized,
                       f"under-size block {'passes' if through else 'blocked'}, over-size {'blocked' if sized else 'passes'}")
            if notches:
                through = not touches(CHECK='"notches"', INDEX=i, GROW=-0.05)
                sized = touches(CHECK='"notches"', INDEX=i, GROW=0.2)
                report(f"{name}: the side notches are cut to their depth", through and sized,
                       f"under-size pin {'passes' if through else 'blocked'}, over-size {'blocked' if sized else 'passes'}")

            thin = []
            reach = (abs(bores[1][0] - bores[2][0]) + bores[0]) / 2  # bending section half-length
            for d, *pts in holes:
                for x, y in pts:
                    end = size[0] / 2 - abs(x) - d / 2
                    side = size[1] / 2 - abs(y) - d / 2
                    bore = abs(x) - reach - d / 2
                    if min(end, side, bore) < 1:
                        thin.append((x, y, round(min(end, side, bore), 2)))
            report(f"{name}: every hole keeps 1 mm of metal to the ends, sides and bores", not thin, thin or "all do")
            report(f"{name}: the gauges cover the bending section", gauge[0] >= 2 * reach,
                   f"gauge {gauge[0]} mm over a {2 * reach:.1f} mm section")

        for i, (name, pcb, colour, chip, headers, mounts) in enumerate(boards):
            result = run(openscad, stl, {"CHECK": '"board"', "INDEX": i})
            n, got = solids_and_size(stl) if result.returncode == 0 else (0, [0, 0, 0])
            pins = sum(h[1] for h in headers)
            report(f"{name}: the board plus {pins} loose pins, {pcb[0]} x {pcb[1]}",
                   n == 1 + pins and abs(got[0] - pcb[0]) < 0.01 and abs(got[1] - pcb[1]) < 0.01,
                   f"{n} pieces, {got[0]:.2f} x {got[1]:.2f}")
            clear = not touches(CHECK='"pins"', INDEX=i)
            report(f"{name}: every pin passes through its hole", clear, "clear" if clear else "a pin touches the board")
            if mounts:
                through = not touches(CHECK='"mounts"', INDEX=i, GROW=-0.05)
                sized = touches(CHECK='"mounts"', INDEX=i, GROW=0.2)
                report(f"{name}: the mounting holes go through at their diameter", through and sized,
                       f"under-size pin {'passes' if through else 'blocked'}, over-size {'blocked' if sized else 'passes'}")

    print("all checks passed" if not failures else f"{len(failures)} failed")
    sys.exit(1 if failures else 0)


main()
