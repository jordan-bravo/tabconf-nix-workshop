use std::{
    io::Read,
    process::{Command, Stdio},
};

fn main() {
    // Run the bitcoin-cli command
    let output = Command::new("bitcoin-cli")
        .arg("--regtest")
        .arg("getblockchaininfo")
        .stdout(Stdio::piped()) // Capture the standard output
        .spawn() // Start the command
        .expect("Failed to execute bitcoin-cli");

    // Wait for the command to complete and capture the output
    let mut child_stdout = output.stdout.expect("Failed to capture stdout");

    // Read the output from the process
    let mut output_string = String::new();
    child_stdout
        .read_to_string(&mut output_string)
        .expect("Failed to read command output");

    // Print the result of bitcoin-cli
    println!("Output from bitcoin-cli: {}", output_string);
}
