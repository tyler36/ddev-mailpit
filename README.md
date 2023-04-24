[![tests](https://github.com/tyler36/ddev-mailpit/actions/workflows/tests.yml/badge.svg)](https://github.com/tyler36/ddev-mailpit/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

# ddev-mailpit <!-- omit in toc -->

- [What is ddev-mailpit?](#what-is-ddev-mailpit)
- [Installation](#installation)
- [Configuring your framework](#configuring-your-framework)
   - [Laravel](#laravel)
   - [Drupal](#drupal)
      - [Option: PHP (legacy)](#option-php-legacy)
      - [SMTP (recommended)](#smtp-recommended)
         - [Drupal Symfony Mailer](#drupal-symfony-mailer)
         - [SMTP Authentication Support](#smtp-authentication-support)
- [Configuration](#configuration)
   - [Replacing Mailhog](#replacing-mailhog)
   - [SMTP relay](#smtp-relay)
      - [Forward all mail](#forward-all-mail)
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

### Drupal

#### Option: PHP (legacy)

Drupal uses the PHP mail function to send mail. On install this addon tries to detect Drupal projects and will write a custom PHP `ini` (`.ddev/php/mailpit.ini`) to set the mail host to `mailpit`.

If you plan on using the "SMTP (recommended)" method below, `.ddev/php/mailpit.ini` can be safely deleted.

#### SMTP (recommended)

Modern Drupal developers often prefer to use SMTP for mail instead of the default PHP functions.
It is recommend to use one of the following popular module instead of PHP (legacy).

- [Drupal Symfony Mailer](https://www.drupal.org/project/symfony_mailer), formerly [Swift Mailer](https://www.drupal.org/project/swiftmailer)
- [SMTP Authentication Support](https://www.drupal.org/project/smtp)

##### Drupal Symfony Mailer

1. Install and enable [Drupal Symfony Mailer](https://www.drupal.org/project/symfony_mailer) module.

   ```shell
   ddev composer require drupal/symfony_mailer
   ddev drush en symfony_mailer
   ```

1. Visit `/admin/config/system/mailer/transport`
1. Add a new mailer transport:
   1. Transport type: `SMTP`
1. Configure the transport
   1. Host name: `mailpit`
   1. Port: `1025`
   1. Save
1. Set the SMTP as the default.
   1. Click the "Edit" operation and "Set as default"

##### SMTP Authentication Support

1. Install and enable the [SMTP](https://www.drupal.org/project/smtp) module.

   ```shell
   ddev composer require drupal/smtp
   ddev drush en smpt
   ```

1. Visit `/admin/config/system/smtp`
1. Ensure the following:
   1. Install options | Set SMTP as the default mail system: `On`
   2. SMTP server settings | SMTP server: '`mailpit`
   3. SMTP server settings | SMTP port: '`1025`

## Configuration

This addon uses 2 environment variables that can be set :

- `MAILPIT_PORT`: Port to listen to for mail; defaults to `1025`
- `MAILPIT_UI_PORT`: Port used to serve UI; defaults to `8026`

See [Providing Custom Environment Variables to a Container](https://ddev.readthedocs.io/en/stable/users/extend/customization-extendibility/#providing-custom-environment-variables-to-a-container) for methods to set these values.

### Replacing Mailhog

This addon is currently designed as a drop-in replacement for Mailhog.

Currently, there is no way to "disable" Mailhog (see [#997](https://github.com/ddev/ddev/issues/997)) so this addon
moves the Mailhog UI to a different port.

To change the Mailhog UI port, update `.ddev/config.mailpit.yaml`:

```yaml
mailhog_port: "9025"
mailhog_https_port: "9026"
```

By default, `ddev launch -m` will open MailHog.
You can update the command to open Mailpit for your project instead by making the following changes.

1. Copy your global `~/.ddev/commands/host/launch` into your project folder to `.ddev/commands/host/launch`.
1. Remove `#ddev-generated` from your project's `.ddev/commands/host/launch` command.
1. Replace the Mailhog section with the following from your project's `.ddev/commands/host/launch`

      ```bash
         -m|--mailhog)
            FULLURL="${FULLURL%:[0-9]*}:8026"
         ;;
      ```

### SMTP relay

Mailpit can be configured to allow you to forward emails to another SMTP.
This addon automatically sets up the configuration file, however, you will need to update the
specific settings for you SMTP server to use.

Update your project's `.ddev/mailpit/config.yaml` file:

1. Remove `#ddev-generated`.
1. Add your SMTP server details.

See [SMTP replay](https://github.com/axllent/mailpit/wiki/SMTP-relay) for more details.

#### Forward all mail

To automatically relay _all_ mail, update `.ddev/docker-compose.mailpit.yaml`:

1. Remove `#ddev-generated`.
1. Add `MP_SMTP_RELAY_ALL` environmental variable.

   ```yaml
    environment:
      ...
      - MP_SMTP_RELAY_ALL=TRUE
   ```

## TODO

- [ ] Improve handling of Mailhog conflict

## Contributing

PRs to improve this addon are welcome.

PRs that add features, especially when covered with tests, will be applauded.

**Contributed and maintained by [@tyler36](https://github.com/tyler36)**
