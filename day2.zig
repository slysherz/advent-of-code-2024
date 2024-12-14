const std = @import("std");
const shared = @import("shared.zig");
var allocator = std.heap.GeneralPurposeAllocator(.{}){};
var gpa = allocator.allocator();

fn valid_diff(a: i64, b: i64) bool {
    const diff: u64 = @abs(a - b);
    return diff > 0 and diff <= 3;
}

fn valid_seq(a: i64, b: i64, c: i64) bool {
    return (a > b) == (b > c);
}

pub fn has_anomaly(lst: []const i64) bool {
    var i: usize = 1;
    while (i < lst.len) : (i += 1) {
        const reversed: bool = i >= 2 and !valid_seq(lst[i], lst[i - 1], lst[i - 2]);
        if (!valid_diff(lst[i], lst[i - 1]) or reversed) {
            return true;
        }
    }

    return false;
}

pub fn main() !void {
    const data = try shared.get_input(gpa);
    defer gpa.free(data);

    var splits = std.mem.tokenize(u8, data, "\n");
    var reports = std.ArrayList(std.ArrayList(i64)).init(gpa);
    while (splits.next()) |line| {
        var report: std.ArrayList(i64) = std.ArrayList(i64).init(gpa);
        var split = std.mem.tokenize(u8, line, " ");

        while (split.next()) |s| {
            try report.append(try std.fmt.parseInt(i64, s, 10));
        }

        try reports.append(report);
    }

    var safe1: u64 = 0;
    var safe2: u64 = 0;
    for (reports.items) |report| {
        const lst: []i64 = report.items;
        if (!has_anomaly(lst)) {
            safe1 += 1;
            safe2 += 1;
        } else {
            for (0..lst.len) |i| {
                var copy = std.ArrayList(i64).init(gpa);
                defer copy.deinit();
                for (0..lst.len) |j| {
                    if (i != j) {
                        try copy.append(lst[j]);
                    }
                }
                if (!has_anomaly(copy.items)) {
                    safe2 += 1;
                    break;
                }
            }
        }
    }

    std.debug.print("Safe part 1: {d}\n", .{safe1});
    std.debug.print("Safe part 2: {d}\n", .{safe2});
}
