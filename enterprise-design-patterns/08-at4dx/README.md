# Advanced Techniques To Adopt SalesforceDX Unlocked Packages

- Use `sfdx-project.json` to define the order of source deploy and a path for pulling the source (the `default` one).

- Install the source code of `apex-mocks`, `apex-common`, and `force-di` into `libs` directory.
- The source code of `at4dx` will be installed in `core` directory.
- Any common object implementation or utilities will go to the `common` directory.
- App specific implementation locations is each ones individual folder (i.e. `my-app`).


---

### References

- [GitHub - Advanced Techniques To Adopt SalesforceDX Unlocked Packages](https://github.com/apex-enterprise-patterns/at4dx)