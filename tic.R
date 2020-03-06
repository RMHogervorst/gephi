do_package_checks()

if (ci_on_travis()) {
    do_pkgdown()
}

if (Sys.getenv("id_rsa") != "") {
    # pkgdown documentation can be built optionally. Other example criteria:
    # - `inherits(ci(), "TravisCI")`: Only for Travis CI
    # - `ci()$is_tag()`: Only for tags, not for branches
    # - `Sys.getenv("BUILD_PKGDOWN") != ""`: If the env var "BUILD_PKGDOWN" is set
    # - `Sys.getenv("TRAVIS_EVENT_TYPE") == "cron"`: Only for Travis cron jobs
    get_stage("before_deploy") %>%
        add_step(step_setup_ssh())

    get_stage("deploy") %>%
        add_code_step(covr::codecov())%>%
        add_code_step(print(Sys.getenv('TRAVIS_COMMIT_MESSAGE')))

    covrpage_flag <- '\\[\\s*(skip\\s+covrpage|covrpage\\s+skip)\\s*\\]'

    if(!grepl(covrpage_flag,Sys.getenv('TRAVIS_COMMIT_MESSAGE'))){
        get_stage("deploy") %>%
            add_code_step(devtools::install())%>%
            add_code_step(
                covrpage::covrpage_ci(update_badge = FALSE),
                prepare_call = remotes::install_github("metrumresearchgroup/covrpage")
            ) %>%
            add_step(step_push_deploy(commit_paths = "tests/README.md"))
    }
}
