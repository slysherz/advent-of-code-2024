const std = @import("std");
const shared = @import("shared.zig");
var allocator = std.heap.GeneralPurposeAllocator(.{}){};
var gpa = allocator.allocator();

const Pos = [2]i64;

fn matches(lst: std.ArrayList([]const u8), letters: []const u8, pos: Pos, x: i64, y: i64) bool {
    var nx = x;
    var ny = y;
    for (letters) |letter| {
        if (nx < 0 or ny < 0 or ny >= lst.items.len or nx >= lst.items[@intCast(ny)].len) {
            return false;
        }
        if (lst.items[@intCast(ny)][@intCast(nx)] != letter) {
            return false;
        }

        nx += pos[0];
        ny += pos[1];
    }

    return true;
}

pub fn main() !void {
    const data = try shared.get_input(gpa);
    defer gpa.free(data);

    var splits = std.mem.split(u8, data, "\n");
    var lines = std.ArrayList([]const u8).init(gpa);
    defer lines.deinit();

    while (splits.next()) |line| {
        try lines.append(line);
    }

    const xmas = "XMAS";
    const possibilities = [_](Pos){ Pos{ 1, 1 }, Pos{ 1, 0 }, Pos{ 1, -1 }, Pos{ 0, 1 }, Pos{ 0, -1 }, Pos{ -1, 1 }, Pos{ -1, 0 }, Pos{ -1, -1 } };
    var result1: i64 = 0;

    const mas = "MAS";
    var result2: i64 = 0;
    for (0..lines.items.len) |uy| {
        for (0..lines.items[uy].len) |ux| {
            const x: i64 = @intCast(ux);
            const y: i64 = @intCast(uy);
            for (possibilities) |pos| {
                if (matches(lines, xmas, pos, x, y)) {
                    result1 += 1;
                }
            }

            const p1 = matches(lines, mas, Pos{ 1, 1 }, x - 1, y - 1);
            const p2 = matches(lines, mas, Pos{ -1, 1 }, x + 1, y - 1);
            const p3 = matches(lines, mas, Pos{ 1, -1 }, x - 1, y + 1);
            const p4 = matches(lines, mas, Pos{ -1, -1 }, x + 1, y + 1);
            const p5 = p1 or p4;
            const p6 = p2 or p3;

            if (p5 and p6) {
                result2 += 1;
            }
        }
    }

    std.debug.print("Result part 1: {d}\n", .{result1});
    std.debug.print("Result part 2: {d}\n", .{result2});
}
