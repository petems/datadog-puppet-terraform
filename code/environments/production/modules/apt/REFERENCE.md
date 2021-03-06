# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

#### Public Classes

* [`apt`](#apt): Main class, includes all other classes.
* [`apt::backports`](#aptbackports): Manages backports.

#### Private Classes

* `apt::params`: Provides defaults for the Apt module parameters.
* `apt::update`: Updates the list of available packages using apt-get update.

### Defined types

* [`apt::conf`](#aptconf): Specifies a custom Apt configuration file.
* [`apt::key`](#aptkey): Manages the GPG keys that Apt uses to authenticate packages.
* [`apt::mark`](#aptmark): defined typeapt::mark
* [`apt::pin`](#aptpin): Manages Apt pins. Does not trigger an apt-get update run.
* [`apt::ppa`](#aptppa): Manages PPA repositories using `add-apt-repository`. Not supported on Debian.
* [`apt::setting`](#aptsetting): Manages Apt configuration files.
* [`apt::source`](#aptsource): Manages the Apt sources in /etc/apt/sources.list.d/.

### Resource types

#### Public Resource types


#### Private Resource types

* `apt_key`: This type provides Puppet with the capabilities to manage GPG keys needed
by apt to perform package validation. Apt has it's own GPG keyring that can
be manipulated through the `apt-key` command.

### Data types

* [`Apt::Auth_conf_entry`](#aptauth_conf_entry): Login configuration settings that are recorded in the file `/etc/apt/auth.conf`.
* [`Apt::Proxy`](#aptproxy): Configures Apt to connect to a proxy server.

### Tasks

* [`init`](#init): Allows you to perform apt functions

## Classes

### `apt`

Main class, includes all other classes.

* **See also**
  * https://docs.puppetlabs.com/references/latest/function.html#createresources
    * for the create resource function

#### Parameters

The following parameters are available in the `apt` class.

##### `provider`

Data type: `String`

Specifies the provider that should be used by apt::update.

Default value: `$apt::params::provider`

##### `keyserver`

Data type: `String`

Specifies a keyserver to provide the GPG key. Valid options: a string containing a domain name or a full URL (http://, https://, or
hkp://).

Default value: `$apt::params::keyserver`

##### `key_options`

Data type: `Optional[String]`

Specifies the default options for apt::key resources.

Default value: `$apt::params::key_options`

##### `ppa_options`

Data type: `Optional[String]`

Supplies options to be passed to the `add-apt-repository` command.

Default value: `$apt::params::ppa_options`

##### `ppa_package`

Data type: `Optional[String]`

Names the package that provides the `apt-add-repository` command.

Default value: `$apt::params::ppa_package`

##### `backports`

Data type: `Optional[Hash]`

Specifies some of the default parameters used by apt::backports. Valid options: a hash made up from the following keys:

Options:

* **:location** `String`: See apt::backports for documentation.
* **:repos** `String`: See apt::backports for documentation.
* **:key** `String`: See apt::backports for documentation.

Default value: `$apt::params::backports`

##### `confs`

Data type: `Hash`

Creates new `apt::conf` resources. Valid options: a hash to be passed to the create_resources function linked above.

Default value: `$apt::params::confs`

##### `update`

Data type: `Hash`

Configures various update settings. Valid options: a hash made up from the following keys:

Options:

* **:frequency** `String`: Specifies how often to run `apt-get update`. If the exec resource `apt_update` is notified, `apt-get update` runs regardless of this value.
Valid options: 'always' (at every Puppet run); 'daily' (if the value of `apt_update_last_success` is less than current epoch time minus 86400);
'weekly' (if the value of `apt_update_last_success` is less than current epoch time minus 604800); and 'reluctantly' (only if the exec resource
`apt_update` is notified). Default: 'reluctantly'.
* **:loglevel** `Integer`: Specifies the log level of logs outputted to the console. Default: undef.
* **:timeout** `Integer`: Specifies how long to wait for the update to complete before canceling it. Valid options: an integer, in seconds. Default: undef.
* **:tries** `Integer`: Specifies how many times to retry the update after receiving a DNS or HTTP error. Default: undef.

Default value: `$apt::params::update`

##### `purge`

Data type: `Hash`

Specifies whether to purge any existing settings that aren't managed by Puppet. Valid options: a hash made up from the following keys:

Options:

* **:sources.list** `Boolean`: Specifies whether to purge any unmanaged entries from sources.list. Default false.
* **:sources.list.d** `Boolean`: Specifies whether to purge any unmanaged entries from sources.list.d. Default false.
* **:preferences** `Boolean`: Specifies whether to purge any unmanaged entries from preferences. Default false.
* **:preferences.d.** `Boolean`: Specifies whether to purge any unmanaged entries from preferences.d. Default false.

Default value: `$apt::params::purge`

##### `proxy`

Data type: `Apt::Proxy`

Configures Apt to connect to a proxy server. Valid options: a hash matching the locally defined type apt::proxy.

Default value: `$apt::params::proxy`

##### `sources`

Data type: `Hash`

Creates new `apt::source` resources. Valid options: a hash to be passed to the create_resources function linked above.

Default value: `$apt::params::sources`

##### `keys`

Data type: `Hash`

Creates new `apt::key` resources. Valid options: a hash to be passed to the create_resources function linked above.

Default value: `$apt::params::keys`

##### `ppas`

Data type: `Hash`

Creates new `apt::ppa` resources. Valid options: a hash to be passed to the create_resources function linked above.

Default value: `$apt::params::ppas`

##### `pins`

Data type: `Hash`

Creates new `apt::pin` resources. Valid options: a hash to be passed to the create_resources function linked above.

Default value: `$apt::params::pins`

##### `settings`

Data type: `Hash`

Creates new `apt::setting` resources. Valid options: a hash to be passed to the create_resources function linked above.

Default value: `$apt::params::settings`

##### `manage_auth_conf`

Data type: `Boolean`

Specifies whether to manage the /etc/apt/auth.conf file. When true, the file will be overwritten with the entries specified in
the auth_conf_entries parameter. When false, the file will be ignored (note that this does not set the file to absent.

Default value: `$apt::params::manage_auth_conf`

##### `auth_conf_entries`

Data type: `Array[Apt::Auth_conf_entry]`

An optional array of login configuration settings (hashes) that are recorded in the file /etc/apt/auth.conf. This file has a netrc-like
format (similar to what curl uses) and contains the login configuration for APT sources and proxies that require authentication. See
https://manpages.debian.org/testing/apt/apt_auth.conf.5.en.html for details. If specified each hash must contain the keys machine, login and
password and no others. Specifying manage_auth_conf and not specifying this parameter will set /etc/apt/auth.conf to absent.

Default value: `$apt::params::auth_conf_entries`

##### `auth_conf_owner`

Data type: `String`

The owner of the file /etc/apt/auth.conf. Default: '_apt' or 'root' on old releases.

Default value: `$apt::params::auth_conf_owner`

##### `root`

Data type: `String`

Specifies root directory of Apt executable.

Default value: `$apt::params::root`

##### `sources_list`

Data type: `String`

Specifies the path of the sources_list file to use.

Default value: `$apt::params::sources_list`

##### `sources_list_d`

Data type: `String`

Specifies the path of the sources_list.d file to use.

Default value: `$apt::params::sources_list_d`

##### `conf_d`

Data type: `String`

Specifies the path of the conf.d file to use.

Default value: `$apt::params::conf_d`

##### `preferences`

Data type: `String`

Specifies the path of the preferences file to use.

Default value: `$apt::params::preferences`

##### `preferences_d`

Data type: `String`

Specifies the path of the preferences.d file to use.

Default value: `$apt::params::preferences_d`

##### `config_files`

Data type: `Hash`

A hash made up of the various configuration files used by Apt.

Default value: `$apt::params::config_files`

##### `sources_list_force`

Data type: `Boolean`

Specifies whether to perform force purge or delete. Default false.

Default value: `$apt::params::sources_list_force`

##### `update_defaults`

Data type: `Hash`



Default value: `$apt::params::update_defaults`

##### `purge_defaults`

Data type: `Hash`



Default value: `$apt::params::purge_defaults`

##### `proxy_defaults`

Data type: `Hash`



Default value: `$apt::params::proxy_defaults`

##### `include_defaults`

Data type: `Hash`



Default value: `$apt::params::include_defaults`

##### `apt_conf_d`

Data type: `String`



Default value: `$apt::params::apt_conf_d`

##### `source_key_defaults`

Data type: `Hash`



Default value: `$apt::params::source_key_defaults`

### `apt::backports`

Manages backports.

#### Examples

##### Set up a backport source for Linux Mint qiana

```puppet
class { 'apt::backports':
  location => 'http://us.archive.ubuntu.com/ubuntu',
  release  => 'trusty-backports',
  repos    => 'main universe multiverse restricted',
  key      => {
    id     => '630239CC130E1A7FD81A27B140976EAF437D05B5',
    server => 'hkps.pool.sks-keyservers.net',
  },
}
```

#### Parameters

The following parameters are available in the `apt::backports` class.

##### `location`

Data type: `Optional[String]`

Specifies an Apt repository containing the backports to manage. Valid options: a string containing a URL. Default value for Debian and
Ubuntu varies:

- Debian: 'http://deb.debian.org/debian'

- Ubuntu: 'http://archive.ubuntu.com/ubuntu'

Default value: ``undef``

##### `release`

Data type: `Optional[String]`

Specifies a distribution of the Apt repository containing the backports to manage. Used in populating the `source.list` configuration file.
Default: on Debian and Ubuntu, '${lsbdistcodename}-backports'. We recommend keeping this default, except on other operating
systems.

Default value: ``undef``

##### `repos`

Data type: `Optional[String]`

Specifies a component of the Apt repository containing the backports to manage. Used in populating the `source.list` configuration file.
Default value for Debian and Ubuntu varies:

- Debian: 'main contrib non-free'

- Ubuntu: 'main universe multiverse restricted'

Default value: ``undef``

##### `key`

Data type: `Optional[Variant[String, Hash]]`

Specifies a key to authenticate the backports. Valid options: a string to be passed to the id parameter of the apt::key defined type, or a
hash of parameter => value pairs to be passed to apt::key's id, server, content, source, and/or options parameters. Default value
for Debian and Ubuntu varies:

- Debian: 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553'

- Ubuntu: '630239CC130E1A7FD81A27B140976EAF437D05B5'

Default value: ``undef``

##### `pin`

Data type: `Optional[Variant[Integer, String, Hash]]`

Specifies a pin priority for the backports. Valid options: a number or string to be passed to the `id` parameter of the `apt::pin` defined
type, or a hash of `parameter => value` pairs to be passed to `apt::pin`'s corresponding parameters.

Default value: `200`

##### `include`

Data type: `Optional[Variant[Hash]]`

Specifies whether to include 'deb' or 'src', or both.

Default value: `{}`

## Defined types

### `apt::conf`

Specifies a custom Apt configuration file.

#### Parameters

The following parameters are available in the `apt::conf` defined type.

##### `content`

Data type: `Optional[String]`

Required unless `ensure` is set to 'absent'. Directly supplies content for the configuration file.

Default value: ``undef``

##### `ensure`

Data type: `Enum['present', 'absent']`

Specifies whether the configuration file should exist. Valid options: 'present' and 'absent'.

Default value: `present`

##### `priority`

Data type: `Variant[String, Integer]`

Determines the order in which Apt processes the configuration file. Files with lower priority numbers are loaded first.
Valid options: a string containing an integer or an integer.

Default value: `50`

##### `notify_update`

Data type: `Optional[Boolean]`

Specifies whether to trigger an `apt-get update` run.

Default value: ``undef``

### `apt::key`

Manages the GPG keys that Apt uses to authenticate packages.

* **Note** The apt::key defined type makes use of the apt_key type, but includes extra functionality to help prevent duplicate keys.

#### Examples

##### Declare Apt key for apt.puppetlabs.com source

```puppet
apt::key { 'puppetlabs':
  id      => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
  server  => 'hkps.pool.sks-keyservers.net',
  options => 'http-proxy="http://proxyuser:proxypass@example.org:3128"',
}
```

#### Parameters

The following parameters are available in the `apt::key` defined type.

##### `id`

Data type: `Pattern[/\A(0x)?[0-9a-fA-F]{8}\Z/, /\A(0x)?[0-9a-fA-F]{16}\Z/, /\A(0x)?[0-9a-fA-F]{40}\Z/]`

Specifies a GPG key to authenticate Apt package signatures. Valid options: a string containing a key ID (8 or 16 hexadecimal
characters, optionally prefixed with "0x") or a full key fingerprint (40 hexadecimal characters).

Default value: `$title`

##### `ensure`

Data type: `Enum['present', 'absent', 'refreshed']`

Specifies whether the key should exist. Valid options: 'present', 'absent' or 'refreshed'. Using 'refreshed' will make keys auto
update when they have expired (assuming a new key exists on the key server).

Default value: `present`

##### `content`

Data type: `Optional[String]`

Supplies the entire GPG key. Useful in case the key can't be fetched from a remote location and using a file resource is inconvenient.

Default value: ``undef``

##### `source`

Data type: `Optional[Pattern[/\Ahttps?:\/\//, /\Aftp:\/\//, /\A\/\w+/]]`

Specifies the location of an existing GPG key file to copy. Valid options: a string containing a URL (ftp://, http://, or https://) or
an absolute path.

Default value: ``undef``

##### `server`

Data type: `Pattern[/\A((hkp|hkps|http|https):\/\/)?([a-z\d])([a-z\d-]{0,61}\.)+[a-z\d]+(:\d{2,5})?(\/[a-zA-Z\d\-_.]+)*\/?$/]`

Specifies a keyserver to provide the GPG key. Valid options: a string containing a domain name or a full URL (http://, https://,
hkp:// or hkps://). The hkps:// protocol is currently only supported on Ubuntu 18.04.

Default value: `$::apt::keyserver`

##### `weak_ssl`

Data type: `Boolean`

Specifies whether strict SSL verification on a https URL should be disabled. Valid options: true or false.

Default value: ``false``

##### `options`

Data type: `Optional[String]`

Passes additional options to `apt-key adv --keyserver-options`.

Default value: `$::apt::key_options`

### `apt::mark`

defined typeapt::mark

#### Parameters

The following parameters are available in the `apt::mark` defined type.

##### `setting`

Data type: `Enum['auto','manual','hold','unhold']`

auto, manual, hold, unhold
specifies the behavior of apt in case of no more dependencies installed
https://manpages.debian.org/sretch/apt/apt-mark.8.en.html

### `apt::pin`

Manages Apt pins. Does not trigger an apt-get update run.

* **See also**
  * http://linux.die.net/man/5/apt_preferences
    * for context on these parameters

#### Parameters

The following parameters are available in the `apt::pin` defined type.

##### `ensure`

Data type: `Optional[Enum['file', 'present', 'absent']]`

Specifies whether the pin should exist. Valid options: 'file', 'present', and 'absent'.

Default value: `present`

##### `explanation`

Data type: `Optional[String]`

Supplies a comment to explain the pin. Default: "${caller_module_name}: ${name}".

Default value: ``undef``

##### `order`

Data type: `Variant[Integer]`

Determines the order in which Apt processes the pin file. Files with lower order numbers are loaded first.

Default value: `50`

##### `packages`

Data type: `Variant[String, Array]`

Specifies which package(s) to pin.

Default value: `'*'`

##### `priority`

Data type: `Variant[Numeric, String]`

Sets the priority of the package. If multiple versions of a given package are available, `apt-get` installs the one with the highest
priority number (subject to dependency constraints). Valid options: an integer.

Default value: `0`

##### `release`

Data type: `Optional[String]`

Tells APT to prefer packages that support the specified release. Typical values include 'stable', 'testing', and 'unstable'.

Default value: `''`

##### `release_version`

Data type: `Optional[String]`

Tells APT to prefer packages that support the specified operating system release version (such as Debian release version 7).

Default value: `''`

##### `component`

Data type: `Optional[String]`

Names the licensing component associated with the packages in the directory tree of the Release file.

Default value: `''`

##### `originator`

Data type: `Optional[String]`

Names the originator of the packages in the directory tree of the Release file.

Default value: `''`

##### `label`

Data type: `Optional[String]`

Names the label of the packages in the directory tree of the Release file.

Default value: `''`

##### `origin`

Data type: `Optional[String]`



Default value: `''`

##### `version`

Data type: `Optional[String]`



Default value: `''`

##### `codename`

Data type: `Optional[String]`



Default value: `''`

### `apt::ppa`

Manages PPA repositories using `add-apt-repository`. Not supported on Debian.

#### Examples

##### Example declaration of an Apt PPA

```puppet
apt::ppa{ 'ppa:openstack-ppa/bleeding-edge': }
```

#### Parameters

The following parameters are available in the `apt::ppa` defined type.

##### `ensure`

Data type: `String`

Specifies whether the PPA should exist. Valid options: 'present' and 'absent'.

Default value: `'present'`

##### `options`

Data type: `Optional[String]`

Supplies options to be passed to the `add-apt-repository` command. Default: '-y'.

Default value: `$::apt::ppa_options`

##### `release`

Data type: `Optional[String]`

Optional if lsb-release is installed (unless you're using a different release than indicated by lsb-release, e.g., Linux Mint).
Specifies the operating system of your node. Valid options: a string containing a valid LSB distribution codename.

Default value: `$facts['lsbdistcodename']`

##### `dist`

Data type: `Optional[String]`

Optional if lsb-release is installed (unless you're using a different release than indicated by lsb-release, e.g., Linux Mint).
Specifies the distribution of your node. Valid options: a string containing a valid distribution codename.

Default value: `$facts['lsbdistid']`

##### `package_name`

Data type: `Optional[String]`

Names the package that provides the `apt-add-repository` command. Default: 'software-properties-common'.

Default value: `$::apt::ppa_package`

##### `package_manage`

Data type: `Boolean`

Specifies whether Puppet should manage the package that provides `apt-add-repository`.

Default value: ``false``

### `apt::setting`

Manages Apt configuration files.

* **See also**
  * https://docs.puppetlabs.com/references/latest/type.html#file-attributes
    * for more information on source and content parameters

#### Parameters

The following parameters are available in the `apt::setting` defined type.

##### `priority`

Data type: `Variant[String, Integer, Array]`

Determines the order in which Apt processes the configuration file. Files with higher priority numbers are loaded first.

Default value: `50`

##### `ensure`

Data type: `Optional[Enum['file', 'present', 'absent']]`

Specifies whether the file should exist. Valid options: 'present', 'absent', and 'file'.

Default value: `file`

##### `source`

Data type: `Optional[String]`

Required, unless `content` is set. Specifies a source file to supply the content of the configuration file. Cannot be used in combination
with `content`. Valid options: see link above for Puppet's native file type source attribute.

Default value: ``undef``

##### `content`

Data type: `Optional[String]`

Required, unless `source` is set. Directly supplies content for the configuration file. Cannot be used in combination with `source`. Valid
options: see link above for Puppet's native file type content attribute.

Default value: ``undef``

##### `notify_update`

Data type: `Boolean`

Specifies whether to trigger an `apt-get update` run.

Default value: ``true``

### `apt::source`

Manages the Apt sources in /etc/apt/sources.list.d/.

#### Examples

##### Install the puppetlabs apt source

```puppet
apt::source { 'puppetlabs':
  location => 'http://apt.puppetlabs.com',
  repos    => 'main',
  key      => {
    id     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
    server => 'hkps.pool.sks-keyservers.net',
  },
}
```

#### Parameters

The following parameters are available in the `apt::source` defined type.

##### `location`

Data type: `Optional[String]`

Required, unless ensure is set to 'absent'. Specifies an Apt repository. Valid options: a string containing a repository URL.

Default value: ``undef``

##### `comment`

Data type: `String`

Supplies a comment for adding to the Apt source file.

Default value: `$name`

##### `ensure`

Data type: `String`

Specifies whether the Apt source file should exist. Valid options: 'present' and 'absent'.

Default value: `present`

##### `release`

Data type: `Optional[String]`

Specifies a distribution of the Apt repository.

Default value: ``undef``

##### `repos`

Data type: `String`

Specifies a component of the Apt repository.

Default value: `'main'`

##### `include`

Data type: `Optional[Variant[Hash]]`

Configures include options. Valid options: a hash of available keys.

Options:

* **:deb** `Boolean`: Specifies whether to request the distribution's compiled binaries. Default true.
* **:src** `Boolean`: Specifies whether to request the distribution's uncompiled source code. Default false.

Default value: `{}`

##### `key`

Data type: `Optional[Variant[String, Hash]]`

Creates a declaration of the apt::key defined type. Valid options: a string to be passed to the `id` parameter of the `apt::key`
defined type, or a hash of `parameter => value` pairs to be passed to `apt::key`'s `id`, `server`, `content`, `source`, and/or
`options` parameters.

Default value: ``undef``

##### `pin`

Data type: `Optional[Variant[Hash, Numeric, String]]`

Creates a declaration of the apt::pin defined type. Valid options: a number or string to be passed to the `id` parameter of the
`apt::pin` defined type, or a hash of `parameter => value` pairs to be passed to `apt::pin`'s corresponding parameters.

Default value: ``undef``

##### `architecture`

Data type: `Optional[String]`

Tells Apt to only download information for specified architectures. Valid options: a string containing one or more architecture names,
separated by commas (e.g., 'i386' or 'i386,alpha,powerpc'). Default: undef (if unspecified, Apt downloads information for all architectures
defined in the Apt::Architectures option).

Default value: ``undef``

##### `allow_unsigned`

Data type: `Boolean`

Specifies whether to authenticate packages from this release, even if the Release file is not signed or the signature can't be checked.

Default value: ``false``

##### `notify_update`

Data type: `Boolean`

Specifies whether to trigger an `apt-get update` run.

Default value: ``true``

## Resource types

## Data types

### `Apt::Auth_conf_entry`

Login configuration settings that are recorded in the file `/etc/apt/auth.conf`.

* **See also**
  * https://manpages.debian.org/testing/apt/apt_auth.conf.5.en.html
  * for more information

Alias of `Struct[{
    machine => String[1],
    login => String,
    password => String
  }]`

#### Parameters

The following parameters are available in the `Apt::Auth_conf_entry` data type.

##### `machine`

Hostname of machine to connect to.

##### `login`

Specifies the username to connect with.

##### `password`

Specifies the password to connect with.

### `Apt::Proxy`

Configures Apt to connect to a proxy server.

Alias of `Struct[{
    ensure     => Optional[Enum['file', 'present', 'absent']],
    host       => Optional[String],
    port       => Optional[Integer[0, 65535]],
    https      => Optional[Boolean],
    https_acng => Optional[Boolean],
    direct     => Optional[Boolean],
  }]`

#### Parameters

The following parameters are available in the `Apt::Proxy` data type.

##### `ensure`

Specifies whether the proxy should exist. Valid options: 'file', 'present', and 'absent'. Prefer 'file' over 'present'.

##### `host`

Specifies a proxy host to be stored in `/etc/apt/apt.conf.d/01proxy`. Valid options: a string containing a hostname.

##### `port`

Specifies a proxy port to be stored in `/etc/apt/apt.conf.d/01proxy`. Valid options: an integer containing a port number.

##### `https`

Specifies whether to enable https proxies.

##### `direct`

Specifies whether or not to use a `DIRECT` https proxy if http proxy is used but https is not.

## Tasks

### `init`

Allows you to perform apt functions

**Supports noop?** false

#### Parameters

##### `action`

Data type: `Enum[update, upgrade, dist-upgrade, autoremove]`

Action to perform 

