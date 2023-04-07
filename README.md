[![tests](https://github.com/ddev/ddev-mailpit/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-mailpit/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

# ddev-mailpit <!-- omit in toc -->

- [What is ddev-mailpit?](#what-is-ddev-mailpit)
- [Installation](#installation)
- [Configuring your framework](#configuring-your-framework)
   - [Laravel](#laravel)
- [Configuration](#configuration)
   - [Mailhog](#mailhog)
- [TODO](#todo)
- [Contributing](#contributing)

## What is ddev-mailpit?

This repository provides the [Mailpit](https://github.com/axllent/mailpit) service to [DDEV](https://ddev.readthedocs.io/).

> [Mailpit](https://github.com/axllent/mailpit) is a multi-platform email testing tool & API for developers.
>
> It acts as both an SMTP server, and provides a web interface to view all captured emails.
>
> Mailpit is inspired by [MailHog](https://github.com/axllent/mailpit#why-rewrite-mailhog), but much, much faster.

Some of the features listed on the Mailpit repo page include:

- Mobile and tablet HTML preview toggle in desktop mode
- Advanced [mail search](https://github.com/axllent/mailpit/wiki/Mail-search)
- [Message tagging](https://github.com/axllent/mailpit/wiki/Tagging)
- Real-time web UI updates using web sockets for new mail
- Configurable automatic email pruning (default keeps the most recent 500 emails)
- Email storage either in a temporary or persistent database
- Fast SMTP processing & storing - approximately 70-100 emails per second depending on CPU, network speed & email size

## Installation

1. In the DDEV project directory launch the command:

   ```shell
   ddev get tyler36/ddev-mailpit
   ```

1. Restart the DDEV instance:

   ```shell
   ddev restart
   ```

1. Open the Mailpit web interface via the url: <http://your-project-name.ddev.site:8026/>

## Configuring your framework

### Laravel

1. Update your project's `.env` file:

   ```shell
   MAIL_MAILER=smtp
   MAIL_HOST=mailpit
   MAIL_PORT=1025
   ```

1. Mailpit intercepts Laravel's mail. View the mail at <http://your-project-name.ddev.site:8026/>

## Configuration

This addon uses 2 environment variables that can be set :

- `MAILPIT_PORT`: Port to listen to for mail; defaults to `1025`
- `MAILPIT_UI_PORT`: Port used to serve UI; defaults to `8026`

See [Providing Custom Environment Variables to a Container](https://ddev.readthedocs.io/en/stable/users/extend/customization-extendibility/#providing-custom-environment-variables-to-a-container) for methods to set these values.

### Mailhog

This addon is currently designed as a drop-in replacement for Mailhog.

Currently, there is no way to "disable" Mailhog (see [#997](https://github.com/ddev/ddev/issues/997)) so this addon
moves the Mailhog UI to a different port.

To change the new Mailhog port, update `.ddev/config.mailpit.yaml`:

```yaml
mailhog_port: "9025"
mailhog_https_port: "9026"
```

## TODO

- [ ] Improve handling of Mailhog conflict

## Contributing

PRs to improve this addon are welcome.

PRs that add features, especially when covered with tests, will be applauded.

**Contributed and maintained by [@tyler36](https://github.com/tyler36)**
