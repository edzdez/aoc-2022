defmodule Day15 do
  # @p1_row 10
  # @p2_x 20
  # @p2_y 20
  @p1_row 2_000_000
  @p2_x 4_000_000
  @p2_y 4_000_000

  def to_coords(line),
    do:
      line
      |> String.split(":")
      |> Enum.map(fn x ->
        %{"x" => x, "y" => y} = Regex.named_captures(~r/x=(?<x>-?\d*), y=(?<y>-?\d*)/, x)
        {String.to_integer(x), String.to_integer(y)}
      end)

  def dist({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)

  def read_data(filename) do
    {:ok, contents} = File.read(filename)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&to_coords/1)
  end

  def locs_no_beacons(input, min_x, max_x, min_y, max_y) do
    beacons =
      input
      |> Enum.map(fn [_, p] -> p end)

    min_x..max_x
    |> Enum.flat_map(fn x ->
      min_y..max_y
      |> Stream.filter(fn y ->
        not Enum.member?(beacons, {x, y})
      end)
      |> Stream.map(fn y -> {x, y} end)
    end)
  end

  def impossible_locs(input, min_x, max_x, min_y, max_y) do
    dists =
      input
      |> Enum.map(fn [x, y] -> dist(x, y) end)

    sources =
      input
      |> Enum.map(fn [p, _] -> p end)

    sources_with_dists = Enum.zip(sources, dists)

    locs_no_beacons(input, min_x, max_x, min_y, max_y)
    |> Stream.filter(fn p1 ->
      sources_with_dists
      |> Enum.any?(fn {p2, d} -> dist(p1, p2) <= d end)
    end)
  end

  def part_1(input) do
    dists =
      input
      |> Enum.map(fn [x, y] -> dist(x, y) end)

    sources =
      input
      |> Enum.map(fn [p, _] -> p end)

    sources_with_dists = Enum.zip(sources, dists)

    extremes =
      sources_with_dists
      |> Stream.filter(fn {{_, y}, d} ->
        abs(y - @p1_row) <= d
      end)
      |> Stream.map(fn {{x, y}, d} ->
        new_d = d - abs(y - @p1_row)
        [x - new_d, x + new_d]
      end)

    {min_x, max_x} =
      extremes
      |> Stream.flat_map(fn x -> x end)
      |> Enum.min_max()

    impossible_locs(input, min_x, max_x, @p1_row, @p1_row)
    |> Enum.count()
  end

  def part_2(input) do
    impossible = impossible_locs(input, 0, @p2_x, 0, @p2_y)

    # [{x, y}] =
    #   locs_no_beacons(input, 0, @p2_x, 0, @p2_y)
    #   |> Enum.filter(fn p -> not Enum.member?(impossible, p) end)

    # x * 4_000_000 + y
    1
  end
end

data = Day15.read_data("day15.in")
IO.puts(Day15.part_1(data))
IO.puts(Day15.part_2(data))
