

pre-commit install 

pre-commit --version 


create file .pre-commit-config.yaml
```
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.52.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
        exclude: ^examples/
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.0.1
    hooks:
      - id: check-merge-conflict
      - id: check-yaml
      - id: check-json
      - id: end-of-file-fixer
      - id: trailing-whitespace
      - id: check-case-conflict

```

git init 
pre-commit install 
git add .
git commit -m "initial commit" 
    - pre-commit will automatically run here 
    - if failures, fix the file run git add and then git commit again


to run manually 
pre-commit run --files

