## 1.0.1 (18 May 2017)

BUG FIXES:

  * #36 Block admin RSS feeds

## 1.0.0 (27 October 2016)

CHANGES:

  * #32 Add additional redis related settings, with sensible defaults.

## 0.5.1 (14 September 2016)

BUG FIXES:

  * #34 Remove ignored logrotate missingok option 

## 0.5.0 (06 May 2016)

CHANGES:

  * #31 Update config-driven-helper to allow for version >= 1.5, < 3.0

## 0.4.2 (03 May 2016)

CHANGES:

  * #25 Abbreviate copyright Limited to LTD for consistency
  * #28 Update code style and spec dependencies

BUG FIXES:

  * #29 Fix an incorrectly named block parameter in etc-local

## 0.4.1 (28 January 2016)

IMPROVEMENTS

  * Add additional new and existing restrictions from .htaccess

## 0.4.0 (10 November 2015)

FEATURES

  * Add a logrotate recipe to the stack for magento logs

BUG FIXES

  * Restrict access to sensitive files in root using new locations syntax

## 0.3.1 (02 October 2015)

FEATURES

  * Add support for include/exclude groups/jobs in AOE Scheduler cron

## 0.3.0 (21 September 2015)

FEATURES

  * Add support for AOE Scheduler cron and watchdog

## 0.2.1 (9 July 2015)

BUG FIXES

 * Fix crypt key attribute path

## 0.2.0 (3 July 2015)

IMPROVEMENTS

 * Reduce duplication in database configuration
 * Reduce restirctions on dependencies

## 0.1.1 (1 July 2015)

FEATURES

 * Add stack recipe

BUG FIXES

 * Fix app attribute path
 * Use raise in place of fatal exceptions

## 0.1.0 (7 June 2015)

FEATURES

  * Initial release of magento-ng
