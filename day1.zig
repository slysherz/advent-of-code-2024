const std = @import("std");
const shared = @import("shared.zig");
var allocator = std.heap.GeneralPurposeAllocator(.{}){};
var gpa = allocator.allocator();

pub fn main() !void {
    const data = try shared.get_input(gpa);
    defer gpa.free(data);

    var splits = std.mem.split(u8, data, "\n");
    var l1 = std.ArrayList(i64).init(gpa);
    defer l1.deinit();
    var l2 = std.ArrayList(i64).init(gpa);
    defer l2.deinit();
    while (splits.next()) |line| {
        // Line looks like this: 87385   28773
        var split = std.mem.tokenize(u8, line, " ");

        const first = split.next();
        const second = split.next();

        if (first == null or second == null) {
            continue;
        }

        try l1.append(try std.fmt.parseInt(i64, first.?, 10));
        try l2.append(try std.fmt.parseInt(i64, second.?, 10));
    }

    // Sort lists
    std.mem.sort(i64, l1.items, {}, comptime std.sort.asc(i64));
    std.mem.sort(i64, l2.items, {}, comptime std.sort.asc(i64));

    const lines = l1.items.len;
    var i: usize = 0;
    var sum: u64 = 0;
    while (i < lines) : (i += 1) {
        sum += @abs(l1.items[i] - l2.items[i]);
    }
    std.debug.print("Sum: {d}\n", .{sum});

    var similarity: i64 = 0;
    var k: usize = 0;
    for (l1.items) |n| {
        while (k < lines and n >= l2.items[k]) : (k += 1) {
            if (n == l2.items[k]) {
                similarity += n;
            }
        }
    }
    std.debug.print("Similarity: {d}\n", .{similarity});
}
