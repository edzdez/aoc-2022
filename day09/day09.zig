const std = @import("std");
const ArrayList = std.ArrayList;
const HashSet = std.AutoHashMap(Point, void);
var gpa = std.heap.GeneralPurposeAllocator(.{}){};

const Instruction = struct { dir: u8, mag: i32 };
const Point = struct { x: i64, y: i64 };

fn readInput(filename: []const u8) !ArrayList(Instruction) {
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var br = std.io.bufferedReader(file.reader());
    var is = br.reader();

    var res = ArrayList(Instruction).init(gpa.allocator());
    var buf: [1024]u8 = undefined;
    while (try is.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try res.append(.{ .dir = line[0], .mag = try std.fmt.parseInt(i32, line[2..], 10) });
    }

    return res;
}

fn touching(headPoint: *const Point, tailPoint: *const Point) bool {
    return @max(headPoint.x, tailPoint.x) - @min(headPoint.x, tailPoint.x) <= 1 and @max(headPoint.y, tailPoint.y) - @min(headPoint.y, tailPoint.y) <= 1;
}

fn makeTouching(headPoint: *Point, tailPoint: *Point) void {
    if (headPoint.x == tailPoint.x) {
        tailPoint.y += if (headPoint.y > tailPoint.y) 1 else -1;
    } else if (headPoint.y == tailPoint.y) {
        tailPoint.x += if (headPoint.x > tailPoint.x) 1 else -1;
    } else {
        tailPoint.x += if (headPoint.x > tailPoint.x) 1 else -1;
        tailPoint.y += if (headPoint.y > tailPoint.y) 1 else -1;
    }
}

fn part1(input: ArrayList(Instruction)) !u32 {
    defer input.deinit();

    var points = HashSet.init(gpa.allocator());
    defer points.deinit();

    var headPoint = Point{ .x = 0, .y = 0 };
    var tailPoint = Point{ .x = 0, .y = 0 };
    try points.put(tailPoint, {});

    for (input.items) |instruction| {
        var i: i32 = 0;
        while (i < instruction.mag) : (i += 1) {
            switch (instruction.dir) {
                'U' => headPoint.y += 1,
                'D' => headPoint.y -= 1,
                'L' => headPoint.x -= 1,
                'R' => headPoint.x += 1,
                else => {},
            }

            if (!touching(&headPoint, &tailPoint)) {
                makeTouching(&headPoint, &tailPoint);
                try points.put(tailPoint, {});
            }
        }
    }

    return points.count();
}

fn part2(input: ArrayList(Instruction)) !u32 {
    defer input.deinit();

    var points = HashSet.init(gpa.allocator());
    defer points.deinit();

    var rope = [_]Point{Point{ .x = 0, .y = 0 }} ** 10;
    try points.put(rope[9], {});

    for (input.items) |instruction| {
        var i: i32 = 0;
        while (i < instruction.mag) : (i += 1) {
            switch (instruction.dir) {
                'U' => rope[0].y += 1,
                'D' => rope[0].y -= 1,
                'L' => rope[0].x -= 1,
                'R' => rope[0].x += 1,
                else => {},
            }

            var j: usize = 0;
            while (j < 9) : (j += 1) {
                if (!touching(&rope[j], &rope[j + 1])) {
                    makeTouching(&rope[j], &rope[j + 1]);
                    try points.put(rope[9], {});
                }
            }
        }
    }

    return points.count();
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    defer _ = gpa.detectLeaks();

    var input = try readInput("day09.in");
    defer input.deinit();

    try stdout.print("{}\n", .{try part1(try input.clone())});
    try stdout.print("{}\n", .{try part2(try input.clone())});
}
