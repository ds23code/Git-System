#!/usr/bin/env python3

with open("a", "r") as file:
    data=file.read()

with open("copy_demo.txt", "w") as copy:
    copy.write(data)