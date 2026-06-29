import os
import re

root = r'c:\Users\eswar\Downloads\aprogra\aprogra\lib\screens'

# Pattern: const CircleAvatar(\n  radius: N,\n  backgroundImage: NetworkImage('https://images.unsplash.com...'),\n)
# Also handles non-const version
pattern = re.compile(
    r'(const\s+)?CircleAvatar\(\s*\n\s+radius:\s*(\d+),\s*\n\s+backgroundImage:\s*NetworkImage\(\'https://images\.unsplash\.com[^\']*\'\),\s*\n\s+\)',
    re.MULTILINE
)

def replacement(m):
    radius = m.group(2)
    return (
        f"CircleAvatar(\n"
        f"              radius: {radius},\n"
        f"              backgroundColor: const Color(0xFFF4F1FF),\n"
        f"              child: Text('A', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8463E9))),\n"
        f"            )"
    )

fixed_files = []
for dirpath, dirnames, filenames in os.walk(root):
    for filename in filenames:
        if filename.endswith('.dart'):
            filepath = os.path.join(dirpath, filename)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            if 'images.unsplash.com' in content:
                new_content = pattern.sub(replacement, content)
                if new_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    fixed_files.append(filename)
                    print(f'Fixed: {filename}')

# Also handle single-line versions like: backgroundImage: NetworkImage('https://images.unsplash...'),
# inside CircleAvatar without const keyword and varying indentation
pattern2 = re.compile(
    r"backgroundImage:\s*NetworkImage\('https://images\.unsplash\.com[^']*'\),",
    re.MULTILINE
)

for dirpath, dirnames, filenames in os.walk(root):
    for filename in filenames:
        if filename.endswith('.dart'):
            filepath = os.path.join(dirpath, filename)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            if 'images.unsplash.com' in content:
                # Just replace the backgroundImage line with backgroundColor + child
                new_content = pattern2.sub(
                    "backgroundColor: const Color(0xFFF4F1FF),\n              child: Text('A', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8463E9))),",
                    content
                )
                if new_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    if filename not in fixed_files:
                        fixed_files.append(filename)
                    print(f'Fixed (inline): {filename}')

print(f'\nTotal files fixed: {len(fixed_files)}')
