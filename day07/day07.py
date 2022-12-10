#!/usr/bin/env python3

# warning: terrible python code
part_1 = 0

def read_input(file):
    with open(file, "r") as f:
        return f.read().replace("$ ","\n").strip().split("\n\n")

def execute_commands(commands):
    fs_root = {"name": "/", "parent": None, "children": {}}
    cwd = fs_root

    for command in commands[1:]:
        if command.startswith("cd"):
            argument = command[3:]
            cwd = cwd["parent"] if argument == ".." else cwd["children"][argument]
        elif command.startswith("ls"):
            for line in command.splitlines()[1:]:
                [a, b] = line.split(" ")
                cwd["children"][b] = {"name": b, "parent": cwd, "children": {}} if a == "dir" else {"name": a, "parent": cwd, "size": int(a)}

    return fs_root

def populate_sizes(filetree):
    global part_1

    if "size" in filetree.keys():
        return filetree["size"]
    else:
        filetree["size"] = sum(populate_sizes(obj) for obj in filetree["children"].values())
        # part 1
        if filetree["size"] <= 100000:
            part_1 += filetree["size"]

        return filetree["size"]

def directories_of(filetree, target_size):
    directories = []
    if "children" in filetree.keys():
        if filetree["size"] >= target_size:
            directories.append(filetree["size"])

        for children in filetree["children"].values():
            directories.extend(directories_of(children, target_size))

    return directories

def part_2(filetree):
    occupied_size = 70000000 - filetree["size"]
    target_size = 30000000 - occupied_size
    criteria = directories_of(filetree, target_size)
    return min(criteria)

def main():
    input = read_input("day07.in")
    filetree = execute_commands(input)
    populate_sizes(filetree)
    print(part_1)
    print(part_2(filetree))

if __name__ == "__main__":
    main()
