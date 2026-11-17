# Part of scripts/srd (see README.md).
# Build PUA codepoint -> glyph name map from every font's ToUnicode + Differences.
import sys, re, json, pypdf
r = pypdf.PdfReader(sys.argv[1])
found = {}
seen = set()
for page in r.pages:
    fonts = page.get('/Resources', {}).get('/Font', {})
    for _, ref in fonts.items():
        f = ref.get_object()
        key = id(f)
        enc = f.get('/Encoding')
        enc = enc.get_object() if enc is not None else None
        if not isinstance(enc, dict) or '/Differences' not in enc or '/ToUnicode' not in f:
            continue
        diffs = {}
        code = 0
        for d in enc['/Differences']:
            if isinstance(d, int):
                code = d
            else:
                diffs[code] = str(d)[1:]
                code += 1
        cmap = f['/ToUnicode'].get_object().get_data().decode('latin-1')
        for src, dst in re.findall(r'<([0-9A-Fa-f]{2})>\s*<([0-9A-Fa-f]{4})>', cmap):
            u = int(dst, 16)
            if 0xE000 <= u <= 0xF8FF and int(src, 16) in diffs:
                found.setdefault(hex(u), set()).add(diffs[int(src, 16)])
print(json.dumps({k: sorted(v) for k, v in sorted(found.items())}, indent=1))
