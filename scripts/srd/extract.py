# Part of scripts/srd (see README.md).
# Raw text of every page, separated by =====PAGE n===== markers.
import sys, pypdf
r = pypdf.PdfReader(sys.argv[1])
out = open(sys.argv[2], 'w')
for i, p in enumerate(r.pages, 1):
    out.write(f"\n=====PAGE {i}=====\n")
    out.write(p.extract_text() or "")
print(len(r.pages), "pages")
