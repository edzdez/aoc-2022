use std::fs;

#[derive(Debug)]
enum Instruction {
    NoOp,
    AddX(i32),
}

impl From<&str> for Instruction {
    fn from(s: &str) -> Self {
        if s.starts_with("noop") {
            Self::NoOp
        } else {
            Self::AddX(s.strip_prefix("addx ").unwrap().parse::<i32>().unwrap())
        }
    }
}

fn read_input(file: &str) -> Vec<Instruction> {
    fs::read_to_string(file)
        .expect("no input file?")
        .trim()
        .split("\n")
        .map(Instruction::from)
        .collect()
}

fn part1(input: &[Instruction]) -> i32 {
    let mut ans = 0;
    let mut cycles = 0;
    let mut x = 1;

    for instruction in input {
        cycles += 1;

        if (cycles - 20) % 40 == 0 {
            // println!("{} * {} = {}", cycles, x, cycles * x);
            ans += cycles * x;
        }

        match instruction {
            Instruction::NoOp => {}
            Instruction::AddX(v) => {
                cycles += 1;

                if (cycles - 20) % 40 == 0 {
                    // println!("{} * {} = {}", cycles, x, cycles * x);
                    ans += cycles * x;
                }

                x += v;
            }
        }
    }

    ans
}

fn write_pixel(screen: &mut String, cycles: i32, x: i32) {
    let curr_col = (cycles - 1) % 40;
    if curr_col == 0 {
        screen.push('\n');
    }

    screen.push(if (curr_col - x as i32).abs() <= 1 {
        '#'
    } else {
        '.'
    });
}

fn part2(input: &[Instruction]) -> String {
    let mut ans = String::new();
    let mut cycles = 0;
    let mut x = 1;

    for instruction in input {
        cycles += 1;
        write_pixel(&mut ans, cycles, x);

        match instruction {
            Instruction::NoOp => {}
            Instruction::AddX(v) => {
                cycles += 1;
                write_pixel(&mut ans, cycles, x);

                x += v;
            }
        }
    }

    ans
}

fn main() {
    let input = read_input("day10.in");
    println!("{}", part1(&input));
    println!("{}", part2(&input));
}
