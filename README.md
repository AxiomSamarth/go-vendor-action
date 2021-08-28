## Table of Content

- [Go Vendor Action](#go-vendor-action)
- [Usage](#usage)
- [Points to Remember](#points-to-remember)
- [Examples](#examples)
- [Contribution Guidelines](#contribution-guidelines)


# Go Vendor Action
This action vendors the latest release of the Go project this is employed for; in the dependant Go project via an automated Pull Request. 

For example, if project `go-release-event` is used by another go project `go-release-consume` then this action will vendor the latest `go-release-event` on to `go-release-consume` everytime when there is a new release of `go-release-event` project.

<hr />

## Usage

An example step of a job using this GitHub action is as follows:

```yaml
- name: Revendor latest version
  uses: AxiomSamarth/go-vendor-action@main
  with:
    # The name of the dependant repository's owner
    # Required: True
    destination_repo_owner: AxiomSamarth

    # The name of the dependant repository which vendors
    # the project in the current scope of this action
    # Required: True
    destination_repo_name: go-release-consume   
```

## Points to remember

- The job consuming this GitHub action should export/declare the following environment variable
    - `GITHUB_USER`: GitHub username whose credentials will be used for git push and pull request actions.
    - `GITHUB_PASSWORD`: [OAuth Token](https://docs.github.com/en/github/extending-github/git-automation-with-oauth-tokens) or [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) of the `GITHUB_USER`.
    - `GITHUB_EMAIL`: Email Id associated with the GitHub account of `GITHUB_USER`.
    - `SRC_REPO_OWNER`: The name of the owner of Go project which is to be vendored into dependant projects.
    - `SRC_REPO_NAME`: The name of the Go project which is to be vendored into dependant projects.

- The recommendation is to create these environment variables using GitHub repository secrets. [Read more](https://docs.github.com/en/actions/reference/encrypted-secrets).

- The `GITHUB_USER` should have write access to the dependant project as this action clones the dependant project (and not fork it), creates a new working branch, vendors the changes in the new branch and raises a pull request to the main branch.

- The GitHub action consuming this should also configure the Git credentials before running this step. A reference step is as shown below

    ```yaml
    - name: Configure Git
        run: |
        echo "github.com:\n- user: $GITHUB_USER\n  oauth_token: ${{ secrets.TOKEN }}\n  protocol: https" > ~/.config/hub
        git config --global user.email $GITHUB_EMAIL
        git config --global user.name $GITHUB_USER
    ```

## Examples

- Check this example workflow defined in `go-release-event` [here](https://github.com/AxiomSamarth/go-release-event/blob/main/.github/workflows/github-action.yml). 

- Example automated [PR](https://github.com/AxiomSamarth/go-release-consume/pull/10) onto [`go-release-consume`](https://github.com/AxiomSamarth/go-release-consume) raised by the above workflow with vendored files of latest release of `go-release-event` project.

## Contribution guidelines
- Please open an issue to report a bug or to suggest improvements. 
- Pull Requests without issues will not be entertained.