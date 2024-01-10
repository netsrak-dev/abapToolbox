# abapToolbox
abapToolbox: A collection of mini-applications simplifying daily tasks within SAP/ABAP environments.

## Tools Provided

<details>

<summary>1. Open the transaction in a new mode with a different language</summary>

**Description:**
This tool allows you to open a transaction in a new mode with a different language setting, enhancing accessibility and ease of use.

**Additional Features:**
- Language selection option during transaction initiation.
- Compatibility with various transaction codes.
- Improved user experience with multilingual support.

**Usage:**
To utilize this tool, simply select the desired language and open the transaction code.

![abapToolbox - Open the transaction in a new mode with a different language](https://github.com/netsrak-dev/abapToolbox/assets/144322707/8528e094-f625-46e4-8be0-ff0c8c2ce764)

**Code/Program:**
[call_tx_spras](/src/zabaptb_call_tx_spras.prog.abap)
</details>

<details>
<summary>2. The FizzBuzz problem in ABAP</summary>

🚀 This ABAP program called [FIZZBUZZ_PROBLEM](/src/zabaptb_fizzbuzz_problem.prog.abap) was initially crafted in just about 10 minutes – ask me if I got the job? 😎 It meets the requirements of the FizzBuzz problem in ABAP and allows comparison between the [original implementation](https://github.com/netsrak-dev/abapToolbox/blob/9820c4bf60f0591e4027338eb3775a787c52d1b4/src/zabaptb_fizzbuzz_problem.prog.abap#L71C1-L83C9) and an [improved version](https://github.com/netsrak-dev/abapToolbox/blob/9820c4bf60f0591e4027338eb3775a787c52d1b4/src/zabaptb_fizzbuzz_problem.prog.abap#L92C1-L113C9) based on suggestions from ChatGPT. 💻

The concept is simple: Numbers from 1 to 100 are printed according to these rules:

- Multiples of 3 are replaced by "Fizz.
- Multiples of 5 are replaced by "Buzz.
- Numbers divisible by both 3 and 5 are replaced by "FizzBuzz.

Inspired by Jeff Atwood's influential blog post "[Why Can't Programmers.. Program?](https://blog.codinghorror.com/why-cant-programmers-program/)" this program aims to demonstrate effective programming skills in ABAP and invites contributions and feedback for further enhancements. Explore the differences between the original and improved logic! This project not only showcases effective ABAP programming but also encourages comparing and analyzing different implementations. Feedback and contributions for further development are warmly welcomed. 🌟

</details>

<details>
<summary>3. ABAP Fibonacci Sequence Generator 🌀</summary>

🔢 Generate the Fibonacci sequence in ABAP! This tool offers both iterative and recursive methods to compute the sequence up to a specified number.

🔄 The iterative approach swiftly calculates the sequence by adding the two preceding numbers until reaching the desired value, ensuring optimal performance in ABAP.

⏳ However, the recursive method faces challenges with larger numbers, causing longer execution times beyond 30 and overflow issues beyond 92 due to data type limitations.

🛠️ Enhance performance by implementing memoization for the recursive method and optimizing data types to mitigate overflow problems with larger sequence numbers.

🚀 Choose the best method based on your sequence number needs! Opt for the iterative approach for faster calculations with larger numbers and the recursive method for smaller values where time isn't a concern.

Note: Exercise caution using the recursive method for larger numbers in this ABAP implementation. Implementing suggested improvements can boost functionality and performance across various sequence ranges.

</details>
---

**License:**
This project is licensed under the terms of the [MIT License](LICENSE). You can find the details in the [LICENSE](LICENSE) file.

---

**Contributions:**
Contributions and suggestions to enhance this tool are welcome! Please feel free to submit pull requests or open issues.
