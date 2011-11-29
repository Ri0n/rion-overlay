#!/usr/bin/env python

import os, shutil
import subprocess
import re

regex = re.compile('leechcraft\-.+')

for dir, dirs, files in os.walk('.'):
    if dir == '.' or dir.startswith('./.hg'):
        continue

    for i in dirs:
        match = regex.match(i)
        if match:
            ebuild_name = "%s-0.4.85.ebuild" % match.group(0)
            print "Copying %s to %s" % (i, ebuild_name)
            shutil.copy(os.path.join(dir, i, "%s-9999.ebuild" % i), os.path.join(dir, i,ebuild_name))

            subprocess.call(['sed', '-i', 's/KEYWORDS=""/KEYWORDS="~amd64 ~x86"/g', ebuild_name], cwd=os.path.join(dir, i))

            print "Running 'repoman fix' on %s" % i
            subprocess.call(['repoman', 'fix'], cwd=os.path.join(dir, i))
