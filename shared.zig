const std = @import("std");
const SplitIterator = std.mem.SplitIterator;

pub fn get_input(allocator: std.mem.Allocator) ![]u8 {
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 2) {
        std.debug.print("Usage: {s} <input_file>\n", .{args[0]});
        return error.InvalidArgument;
    }
    const filename: []u8 = args[1];
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const data = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    // defer allocator.free(data);
    return data;
}

pub fn len(iterator: *const std.mem.SplitIterator(u8, .sequence)) u32 {
    var it = iterator.*;
    var lines: u32 = 0;
    while (it.next()) |_| {
        lines += 1;
    }
    return lines;
}
