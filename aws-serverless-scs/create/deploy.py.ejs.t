---
to: deploy.py
---
#!/usr/bin/env python3
import os

bashCommand = "terraform plan"
os.system(bashCommand)
