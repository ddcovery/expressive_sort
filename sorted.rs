fn sorted(xs: Vec<f64>) -> Vec<f64> {
    if xs.is_empty() {
        return [].to_vec();
    }
    let pivot = xs[0];
    let rest = &xs[1..];
    let start = sorted(rest.iter().copied().filter(|x| x < &pivot).collect());
    let end = sorted(rest.iter().copied().filter(|x| x >= &pivot).collect());
    [&start[..], &[pivot], &end[..]].concat()
}

fn main() {
    println!("TODO: implement benchmarks, more tests or whatever you want here...");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn simple_tests() {
        assert_eq!(sorted([].to_vec()), [].to_vec());
        assert_eq!(sorted([0.1].to_vec()), [0.1].to_vec());
        assert_eq!(
            sorted([2.0, 1.8, 1.56, 1.10].to_vec()),
            [1.1, 1.56, 1.8, 2.0].to_vec()
        );
    }
}
