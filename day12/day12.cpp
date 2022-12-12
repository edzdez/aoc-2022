#include <array>
#include <fstream>
#include <iostream>
#include <limits>
#include <queue>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

constexpr auto filename = "day12.in";

auto readInput(std::string_view filename) -> std::vector<std::vector<char>>
{
    std::ifstream fin(filename.data());
    std::vector<std::vector<char>> graph;

    std::string line;
    while (std::getline(fin, line))
        graph.emplace_back(line.cbegin(), line.cend());

    return graph;
}

constexpr std::array<int, 4> dx = {1, -1, 0, 0};
constexpr std::array<int, 4> dy = {0, 0, 1, -1};

auto bfs(const std::vector<std::vector<char>> &graph, const std::pair<int, int> &start, const std::pair<int, int> &end)
    -> int
{
    std::vector<std::vector<bool>> visited(graph.size(), std::vector<bool>(graph[0].size(), false));
    std::queue<std::pair<std::pair<int, int>, int>> q;
    q.push({start, 0});
    visited[start.first][start.second] = true;

    while (!q.empty())
    {
        const auto [p, steps] = q.front();
        if (p == end)
            return steps;

        const auto [y, x] = p;
        q.pop();

        for (int i = 0; i < 4; ++i)
        {
            const int absX = x + dx[i], absY = y + dy[i];
            if (absX < 0 || absX >= (int)graph[0].size() || absY < 0 || absY >= (int)graph.size())
                continue;

            if (!visited[absY][absX] && graph[absY][absX] - graph[y][x] <= 1)
            {
                q.push({{absY, absX}, steps + 1});
                visited[absY][absX] = true;
            }
        }
    }

    return std::numeric_limits<int>::max();
}

auto part1(std::vector<std::vector<char>> graph) -> int
{
    std::pair<int, int> start, end;
    for (int i = 0; i < (int)graph.size(); ++i)
    {
        for (int j = 0; j < (int)graph[0].size(); ++j)
        {
            if (graph[i][j] == 'S')
            {
                start = {i, j};
                graph[i][j] = 'a';
            }
            else if (graph[i][j] == 'E')
            {
                end = {i, j};
                graph[i][j] = 'z';
            }
        }
    }

    return bfs(graph, start, end);
}

auto part2(std::vector<std::vector<char>> graph) -> int
{
    std::pair<int, int> end;
    for (int i = 0; i < static_cast<int>(graph.size()); ++i)
    {
        for (int j = 0; j < static_cast<int>(graph[0].size()); ++j)
        {
            if (graph[i][j] == 'S')
                graph[i][j] = 'a';
            else if (graph[i][j] == 'E')
            {
                end = {i, j};
                graph[i][j] = 'z';
            }
        }
    }

    auto ans = std::numeric_limits<int>::max();
    for (int i = 0; i < static_cast<int>(graph.size()); ++i)
    {
        for (int j = 0; j < static_cast<int>(graph[0].size()); ++j)
        {
            if (graph[i][j] == 'a')
                ans = std::min(ans, bfs(graph, {i, j}, end));
        }
    }

    return ans;
}

auto main() -> int
{
    auto input = readInput(filename);
    std::cout << part1(input) << '\n';
    std::cout << part2(input) << '\n';
}
