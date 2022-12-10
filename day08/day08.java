import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.io.*;

public class day08 {
    public static List<List<Integer>> readInput(String filename) throws IOException {
        var fin = new BufferedReader(new FileReader(filename));
        var res = fin.lines().filter(Predicate.not(String::isBlank)).map(s -> {
            return s.chars().map(c -> c - '0').boxed().toList();
        }).toList();
        fin.close();
        return res;
    }

    public static long part1(List<List<Integer>> input) {
        var rows = input.size();
        var cols = input.get(0).size();
        var visible = new ArrayList<ArrayList<Boolean>>();
        for (var row : input) {
            var rowList = new ArrayList<Boolean>();
            for (var col : row)
                rowList.add(false);
            visible.add(rowList);
        }

        // left and right
        for (var i = 0; i < rows; ++i) {
            var maxLeft = -1;
            var maxRight = -1;

            for (var j = 0; j < cols; ++j) {
                if (input.get(i).get(j) > maxLeft) {
                    maxLeft = input.get(i).get(j);
                    visible.get(i).set(j, true);
                }
                if (input.get(i).get(cols - 1 - j) > maxRight) {
                    maxRight = input.get(i).get(cols - 1 - j);
                    visible.get(i).set(cols - 1 - j, true);
                }
            }
        }

        // top and bottom
        for (var i = 0; i < cols; ++i) {
            var maxTop = -1;
            var maxBottom = -1;

            for (var j = 0; j < rows; ++j) {
                if (input.get(j).get(i) > maxTop) {
                    maxTop = input.get(j).get(i);
                    visible.get(j).set(i, true);
                }
                if (input.get(rows - 1 - j).get(i) > maxBottom) {
                    maxBottom = input.get(rows - 1 - j).get(i);
                    visible.get(rows - 1 - j).set(i, true);
                }
            }
        }

        return visible.stream().flatMap(Collection::stream).filter(c -> c).count();
    }

    public static int scenicScore(List<List<Integer>> input, int row, int col) {
        var rows = input.size();
        var cols = input.get(0).size();

        int left = 0, right = 0, top = 0, bottom = 0;

        // left
        for (int i = col - 1; i >= 0; --i) {
            ++left;
            if (input.get(row).get(i) >= input.get(row).get(col))
                break;
        }

        // right
        for (int i = col + 1; i < cols; ++i) {
            ++right;
            if (input.get(row).get(i) >= input.get(row).get(col))
                break;
        }

        // top
        for (int i = row - 1; i >= 0; --i) {
            ++top;
            if (input.get(i).get(col) >= input.get(row).get(col))
                break;
        }

        // bottom
        for (int i = row + 1; i < rows; ++i) {
            ++bottom;
            if (input.get(i).get(col) >= input.get(row).get(col))
                break;
        }

        // System.out.printf("%d,%d: %d * %d * %d * %d\n", row, col, top, bottom, left,
        // right);
        return left * right * top * bottom;
    }

    public static int part2(List<List<Integer>> input) {
        var rows = input.size();
        var cols = input.get(0).size();

        var res = 0;
        for (var i = 1; i < rows - 1; ++i) {
            for (var j = 1; j < cols - 1; ++j) {
                res = Math.max(res, scenicScore(input, i, j));
            }
        }

        return res;
    }

    public static void main(String[] args) {
        try {
            var input = readInput("day08.in");
            System.out.println(part1(input));
            System.out.println(part2(input));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
