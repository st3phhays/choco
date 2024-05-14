#Requires -PSEdition Desktop
# Copyright © 2017 Chocolatey Software, Inc
# Copyright © 2011 - 2017 RealDimensions Software, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Special thanks to Glenn Sarti (https://github.com/glennsarti) for his help on this.

$ErrorActionPreference = 'Stop'

$thisDirectory = (Split-Path -Parent $MyInvocation.MyCommand.Definition);
$psModuleName = 'chocolateyInstaller'
$psModuleLocation = [System.IO.Path]::GetFullPath("$thisDirectory\src\chocolatey.resources\helpers\chocolateyInstaller.psm1")
$docsFolder = [System.IO.Path]::GetFullPath("$thisDirectory\docs\generated")
$mergedDirectory = [System.IO.Path]::GetFullPath("$thisDirectory\code_drop\temp\_PublishedApps\choco_merged")
$chocoExe = "$mergedDirectory\choco.exe"
$lineFeed = "`r`n"
$sourceLocation = 'https://github.com/chocolatey/choco/blob/master/'
$sourceCommands = $sourceLocation + 'src/chocolatey/infrastructure.app/commands'
$sourceFunctions = $sourceLocation + 'src/chocolatey.resources/helpers/functions'
$global:powerShellReferenceTOC = @'
---
order: 40
xref: powershell-reference
title: PowerShell Reference
description: PowerShell Functions aka Helpers Reference
---
import Xref from '@components/Xref.astro';

# PowerShell Functions aka Helpers Reference

{/* This documentation file is automatically generated from the files at $sourceFunctions using $($sourceLocation)GenerateDocs.ps1. Contributions are welcome at the original location(s). */}

## Summary

In your Chocolatey packaging, you have the ability to use these functions (and others with Chocolatey's <Xref title="PowerShell Extensions" value="extensions" />) to work with all aspects of software management. Keep in mind Chocolatey's automation scripts are just PowerShell, so you can do manage anything you want.

> :choco-info: **NOTE**
>
> These scripts are for package scripts, not for use directly in PowerShell. This is in the create packages section, not the using Chocolatey section.

## Main Functions

These functions call other functions and many times may be the only thing you need in your <Xref title="chocolateyInstall.ps1 file" value="chocolatey-install-ps1" />.

* <Xref title="Install-ChocolateyPackage" value="install-chocolateypackage" />
* <Xref title="Install-ChocolateyZipPackage" value="install-chocolateyzippackage" />
* <Xref title="Install-ChocolateyPowershellCommand" value="install-chocolateypowershellcommand" />
* <Xref title="Install-ChocolateyVsixPackage" value="install-chocolateyvsixpackage" />

## More Functions

### Administrative Access Functions

When creating packages that need to run one of the following commands below, one should add the tag `admin` to the nuspec.

* <Xref title="Install-ChocolateyPackage" value="install-chocolateypackage" />
* <Xref title="Start-ChocolateyProcessAsAdmin" value="start-chocolateyprocessasadmin" />
* <Xref title="Install-ChocolateyInstallPackage" value="install-chocolateyinstallpackage" />
* <Xref title="Install-ChocolateyPath" value="install-chocolateypath" /> - when specifying machine path
* <Xref title="Install-ChocolateyEnvironmentVariable" value="install-chocolateyenvironmentvariable" /> - when specifying machine path
* <Xref title="Install-ChocolateyExplorerMenuItem" value="install-chocolateyexplorermenuitem" />
* <Xref title="Install-ChocolateyFileAssociation" value="install-chocolateyfileassociation" />

### Non-Administrator Safe Functions

When you have a need to run Chocolatey without Administrative access required (non-default install location), you can run the following functions without administrative access.

These are the functions from above as one list.

* <Xref title="Install-ChocolateyZipPackage" value="install-chocolateyzippackage" />
* <Xref title="Install-ChocolateyPowershellCommand" value="install-chocolateypowershellcommand" />
* <Xref title="Get-ChocolateyPath" value="get-chocolateypath" />
* <Xref title="Get-ChocolateyWebFile" value="get-chocolateywebfile" />
* <Xref title="Get-ChocolateyUnzip" value="get-chocolateyunzip" />
* <Xref title="Install-ChocolateyPath" value="install-chocolateypath" /> - when specifying user path
* <Xref title="Install-ChocolateyEnvironmentVariable" value="install-chocolateyenvironmentvariable" /> - when specifying user path
* <Xref title="Install-ChocolateyPinnedTaskBarItem" value="install-chocolateypinnedtaskbaritem" />
* <Xref title="Install-ChocolateyShortcut" value="install-chocolateyshortcut" />
* <Xref title="Update-SessionEnvironment" value="update-sessionenvironment" />
* <Xref title="Get-PackageParameters" value="get-packageparameters" />

## Complete List (alphabetical order)

'@

if (!(Test-Path "$mergedDirectory\lib")) {
    # Workaround for the warning outputted when the directory doesn't exist
    $null = New-Item -Path "$mergedDirectory\lib" -ItemType Directory
}

function Get-Aliases($commandName) {

    $aliasOutput = ''
    Get-Alias -Definition $commandName -ErrorAction SilentlyContinue | ForEach-Object { $aliasOutput += "``$($_.Name)``$lineFeed" }

    if ($aliasOutput -eq $null -or $aliasOutput -eq '') {
        $aliasOutput = 'None'
    }

    Write-Output $aliasOutput
}

function Convert-Example($objItem) {
    @"
**$($objItem.title.Replace('-','').Trim())**

~~~powershell
$($objItem.Code.Replace("`n",$lineFeed))
$($objItem.remarks | Where-Object { $_.Text } | ForEach-Object { $_.Text.Replace("`n", $lineFeed) })
~~~
"@
}

function Replace-CommonItems($text) {
    if ($text -eq $null) {
        return $text
    }

    $text = $text.Replace("`n", $lineFeed)
    $text = $text -replace "\*\*NOTE:\*\*", '> :choco-info: **NOTE**
>
>'
    $text = $text -replace "\*\*WARNING:\*\*",'> :choco-warning: **WARNING**
>
>'
    $text = $text -replace '(community feed[s]?[^\]]|community repository)', '[$1](https://community.chocolatey.org/packages)'
    $text = $text -replace '(Chocolatey for Business|Chocolatey Professional|Chocolatey Pro)(?=[^\w])', '[$1](https://chocolatey.org/compare)'
    $text = $text -replace '(Pro[fessional]\s?/\s?Business)', '[$1](https://chocolatey.org/compare)'
    $text = $text -replace '([Ll]icensed editions)', '[$1](https://chocolatey.org/compare)'
    $text = $text -replace '([Ll]icensed versions)', '[$1](https://chocolatey.org/compare)'
    $text = $text -replace '\[automatic packaging\]\(https://docs.chocolatey.org/en-us/create/automatic-packages\)', '<Xref title="automatic packaging" value="automatic-packaging" />'
    $text = $text -replace 'Learn more about using this at https://docs.chocolatey.org/en-us/guides/create/parse-packageparameters-argument', '<Xref title="Learn more" value="parse-package-parameters" />'
    $text = $text -replace 'at https://docs.chocolatey.org/en-us/guides/create/parse-packageparameters-argument#step-3---use-core-community-extension', 'in <Xref title="the docs" value="parse-package-parameters" anchor="step-3-use-core-community-extension" />'
    $text = $text -replace 'https://docs.chocolatey.org/en-us/guides/create/parse-packageparameters-argument', 'https://docs.chocolatey.org/en-us/guides/create/parse-packageparameters-argument'
    $text = $text -replace '\[community feed\)\]\(https://community.chocolatey.org/packages\)', '[community feed](https://community.chocolatey.org/packages))'

    Write-Output $text
}

function Convert-Syntax($objItem, $hasCmdletBinding) {
    $cmd = $objItem.Name

    if ($objItem.parameter -ne $null) {
        $objItem.parameter | ForEach-Object {
            $cmd += ' `' + $lineFeed
            $cmd += "  "
            if ($_.required -eq $false) {
                $cmd += '['
            }
            $cmd += "-$($_.name.substring(0,1).toupper() + $_.name.substring(1))"


            if ($_.parameterValue -ne $null) {
                $cmd += " <$($_.parameterValue)>"
            }
            if ($_.parameterValueGroup -ne $null) {
                $cmd += " {" + ($_.parameterValueGroup.parameterValue -join ' | ') + "}"
            }
            if ($_.required -eq $false) {
                $cmd += ']'
            }
        }
    }
    if ($hasCmdletBinding) {
        $cmd += " [<CommonParameters>]"
    }
    Write-Output "$lineFeed~~~powershell$lineFeed$($cmd)$lineFeed~~~"
}

function Convert-Parameter($objItem, $commandName) {
    $paramText = $lineFeed + "###  -$($objItem.name.substring(0,1).ToUpper() + $objItem.name.substring(1))"
    if ( ($objItem.parameterValue -ne $null) -and ($objItem.parameterValue -ne 'SwitchParameter') ) {
        $paramText += ' '
        if ([string]($objItem.required) -eq 'false') {
            $paramText += "["
        }
        $paramText += "&lt;$($objItem.parameterValue)&gt;"
        if ([string]($objItem.required) -eq 'false') {
            $paramText += "]"
        }
    }
    $paramText += $lineFeed
    if ($objItem.description -ne $null) {
        $parmText += (($objItem.description | ForEach-Object { Replace-CommonItems $_.Text }) -join "$lineFeed") + $lineFeed + $lineFeed
    }
    if ($objItem.parameterValueGroup -ne $null) {
        $paramText += "$($lineFeed)Valid options: " + ($objItem.parameterValueGroup.parameterValue -join ", ") + $lineFeed + $lineFeed
    }

    $aliases = [string]((Get-Command -Name $commandName).parameters."$($objItem.Name)".Aliases -join ', ')
    $required = [string]($objItem.required)
    $position = [string]($objItem.position)
    $defValue = [string]($objItem.defaultValue -replace '@{Headers = @{}', '`@{Headers = @{}`' )
    $acceptPipeline = [string]($objItem.pipelineInput)

    $padding = ($aliases.Length, $required.Length, $position.Length, $defValue.Length, $acceptPipeline.Length | Measure-Object -Maximum).Maximum

    $paramText += @"
Property               | Value
---------------------- | $([string]('-' * $padding))
Aliases                | $($aliases)
Required?              | $($required)
Position?              | $($position)
Default Value          | $($defValue)
Accept Pipeline Input? | $($acceptPipeline)

"@

    Write-Output $paramText
}

function Convert-CommandText {
    param(
        [string]$commandText,
        [string]$commandName = ''
    )
    if ( $commandText -match '^\s?NOTE: Options and switches apply to all items passed, so if you are\s?$' `
            -or $commandText -match '^\s?installing multiple packages, and you use \`\-\-version\=1\.0\.0\`, it is\s?$' `
            -or $commandText -match '^\s?going to look for and try to install version 1\.0\.0 of every package\s?$' `
            -or $commandText -match '^\s?passed\. So please split out multiple package calls when wanting to\s?$' `
            -or $commandText -match '^\s?pass specific options\.\s?$' `
    ) {
        return
    }
    $commandText = $commandText -creplace '^(.+)(\s+Command\s*)$', "# `$1`$2 (choco $commandName)"
    $commandText = $commandText -creplace '^(DEPRECATION NOTICE|Usage|Troubleshooting|Examples|Exit Codes|Connecting to Chocolatey.org|See It In Action|Alternative Sources|Resources|Packages.config|Scripting \/ Integration - Best Practices \/ Style Guide)', '## $1'
    $commandText = $commandText -replace '^(Commands|How To Pass Options)', '## $1'
    $commandText = $commandText -replace '^(Windows Features|Ruby|Cygwin|Python)\s*$', '### $1'
    $commandText = $commandText -replace '(?<!\s)NOTE:', '> :choco-info: **NOTE**'
    $commandText = $commandText -replace '(?<!\s)WARNING:', '> :choco-warning: **WARNING**'
    $commandText = $commandText -replace '\*> :choco-(info|warning): \*\*(INFO|WARNING|NOTE)\*\*\*', '> :choco-$1: **$2**'
    $commandText = $commandText -replace 'the command reference', '<Xref title="how to pass arguments" value="choco-commands" anchor="how-to-pass-options-switches" />'
    $commandText = $commandText -replace '(community feed[s]?|community repository)', '[$1](https://community.chocolatey.org/packages)'
    #$commandText = $commandText -replace '\`(apikey|install|upgrade|uninstall|list|search|info|outdated|pin)\`', '[[`$1`|Commands$1]]'
    $commandText = $commandText -replace '\`([choco\s]*)(apikey|install|upgrade|uninstall|list|search|info|outdated|pin)\`', '<Xref title="`$1$2`" value="choco-command-`$2`" />'
    $commandText = $commandText -replace '^(.+):\s(.+.gif)$', '![$1]($2)'
    $commandText = $commandText -replace '^(\s+)\<\?xml', "~~~xml$lineFeed`$1<?xml"
    $commandText = $commandText -replace '^(\s+)</packages>', "`$1</packages>$lineFeed~~~"
    $commandText = $commandText -replace '(Chocolatey for Business|Chocolatey Professional|Chocolatey Pro)(?=[^\w])', '[$1](https://chocolatey.org/compare)'
    $commandText = $commandText -replace '(Pro[fessional]\s?/\s?Business)', '[$1](https://chocolatey.org/compare)'
    $commandText = $commandText -replace '([Ll]icensed editions)', '[$1](https://chocolatey.org/compare)'
    $commandText = $commandText -replace '([Ll]icensed versions)', '[$1](https://chocolatey.org/compare)'
    $commandText = $commandText -replace 'https://raw.githubusercontent.com/wiki/chocolatey/choco/images', '/images'
    $commandText = $commandText -replace 'https://chocolatey.org/docs/features-automatically-recompile-packages', 'https://docs.chocolatey.org/en-us/guides/create/recompile-packages'
    $commandText = $commandText -replace 'https://chocolatey.org/docs/features-private-cdn', 'https://docs.chocolatey.org/en-us/features/private-cdn'
    $commandText = $commandText -replace 'https://chocolatey.org/docs/features-virus-check', 'https://docs.chocolatey.org/en-us/features/virus-check'
    $commandText = $commandText -replace 'https://chocolatey.org/docs/features-synchronize', 'https://docs.chocolatey.org/en-us/features/package-synchronization'
    $commandText = $commandText -replace 'explicity', 'explicit'
    $commandText = $commandText -replace 'https://chocolatey.org/docs/features-create-packages-from-installers', 'https://docs.chocolatey.org/en-us/features/package-builder'
    $commandText = $commandText -replace 'See https://chocolatey.org/docs/features-create-packages-from-installers', 'See more information about <Xref title="Package Builder features" value="package-builder" />'
    $commandText = $commandText -replace 'See https://docs.chocolatey.org/en-us/features/package-builder', 'See more information about <Xref title="Package Builder features" value="package-builder" />'
    $commandText = $commandText -replace 'https://chocolatey.org/docs/features-install-directory-override', 'https://docs.chocolatey.org/en-us/features/install-directory-override'
    $commandText = $commandText -replace 'y.org/docs/features-package-reducer', 'y.org/docs/en-us/features/package-reducer'
    $commandText = $commandText -replace 'https://chocolatey.org/docs/features-package-reducer', 'https://docs.chocolatey.org/en-us/features/package-reducer'
    $commandText = $commandText -replace 'https://chocolatey.org/docs/en-us/features/package-reducer', 'https://docs.chocolatey.org/en-us/features/package-reducer'
    $commandText = $commandText -replace '\[community feed\)\]\(https://community.chocolatey.org/packages\)', '[community feed](https://community.chocolatey.org/packages))'
    $commandText = $commandText -replace '> :choco-(info|warning): \*\*(INFO|WARNING|NOTE)\*\*\s', '> :choco-$1: **$2**
>
> '

    $optionsSwitches = @'
## $1

> :choco-info: **NOTE**
>
> Options and switches apply to all items passed, so if you are
 running a command like install that allows installing multiple
 packages, and you use `--version=1.0.0`, it is going to look for and
 try to install version 1.0.0 of every package passed. So please split
 out multiple package calls when wanting to pass specific options.

Includes <Xref title="default options/switches" value="choco-commands" anchor="default-options-and-switches" /> (included below for completeness).

~~~
'@

    $commandText = $commandText -replace '^(Options and Switches)', $optionsSwitches

    $optionsSwitches = @'
## $1

> :choco-info: **NOTE**
>
> Options and switches apply to all items passed, so if you are
 running a command like install that allows installing multiple
 packages, and you use `--version=1.0.0`, it is going to look for and
 try to install version 1.0.0 of every package passed. So please split
 out multiple package calls when wanting to pass specific options.

~~~
'@

    $commandText = $commandText -replace '^(Default Options and Switches)', $optionsSwitches

    Write-Output $commandText
}

function Convert-CommandReferenceSpecific($commandText) {
    $commandText = [Regex]::Replace($commandText, '\s?\s?\*\s(\w+)\s\-',
        {
            param($m)
            $commandName = $m.Groups[1].Value
            $commandNameUpper = $($commandName.Substring(0, 1).ToUpper() + $commandName.Substring(1))
            " * <Xref title='$commandName' value='choco-command-$commandName' /> -"
        }
    )
    #$commandText = $commandText -replace '\s?\s?\*\s(\w+)\s\-', ' * [[$1|Commands$1]] -'
    $commandText = $commandText.Replace("## Default Options and Switches", "## See Help Menu In Action$lineFeed$lineFeed![choco help in action](/images/gifs/choco_help.gif)$lineFeed$lineFeed## Default Options and Switches")

    Write-Output $commandText
}

function Generate-TopLevelCommandReference {
    Write-Host "Generating Top Level Command Reference"
    $fileName = "$docsFolder\choco\commands\index.mdx"
    $commandOutput = @("---")
    $commandOutput += @("order: 40")
    $commandOutput += @("xref: choco-commands")
    $commandOutput += @("title: Commands")
    $commandOutput += @("description: Full list of all available Chocolatey commands")
    $commandOutput += @("---")
    $commandOutput += @("import Xref from '@components/Xref.astro';$lineFeed")
    $commandOutput += @("# Command Reference$lineFeed")
    $commandOutput += @("{/* This file is automatically generated based on output from the files at $sourceCommands using $($sourceLocation)GenerateDocs.ps1. Contributions are welcome at the original location(s). */} $lineFeed")
    $commandOutput += $(& $chocoExe -? -r)
    $commandOutput += @("$lineFeed~~~$lineFeed")
    $commandOutput += @("$lineFeed$lineFeed> :choco-info: **NOTE**$lineFeed>$lineFeed> This documentation has been automatically generated from ``choco -h``. $lineFeed")

    $commandOutput |
        ForEach-Object { Convert-CommandText($_) } |
        ForEach-Object { Convert-CommandReferenceSpecific($_) } |
        Out-File $fileName -Encoding UTF8 -Force
}

function Move-GeneratedFiles {
    if (-not(Test-Path "$docsFolder\create\commands")) {
        New-Item -ItemType Directory -Path "$docsFolder\create\commands" -ErrorAction Continue | Out-Null
    }

    Move-Item -Path "$docsFolder\choco\commands\apikey.mdx" -Destination "$docsFolder\create\commands\api-key.mdx"
    Move-Item -Path "$docsFolder\choco\commands\new.mdx" -Destination "$docsFolder\create\commands\new.mdx"
    Move-Item -Path "$docsFolder\choco\commands\pack.mdx" -Destination "$docsFolder\create\commands\pack.mdx"
    Move-Item -Path "$docsFolder\choco\commands\push.mdx" -Destination "$docsFolder\create\commands\push.mdx"
    Move-Item -Path "$docsFolder\choco\commands\template.mdx" -Destination "$docsFolder\create\commands\template.mdx"
    Move-Item -Path "$docsFolder\choco\commands\templates.mdx" -Destination "$docsFolder\create\commands\templates.mdx"
    Move-Item -Path "$docsFolder\choco\commands\convert.mdx" -Destination "$docsFolder\create\commands\convert.mdx"
}

function Generate-CommandReference($commandName, $order) {
    if (-not(Test-Path "$docsFolder\choco\commands")) {
        New-Item -ItemType Directory -Path "$docsFolder\choco\commands" -ErrorAction Continue | Out-Null
    }
    $fileName = Join-Path "$docsFolder\choco\commands" "$($commandName.ToLower()).mdx"
    $commandNameLower = $commandName.ToLower()

    Write-Host "Generating $fileName ..."
    $commandOutput += @("---")
    $commandOutput += @("order: $order")
    $commandOutput += @("xref: choco-command-$commandNameLower")
    $commandOutput += @("title: $commandName")
    $commandOutput += @("description: $commandName Command (choco $commandNameLower)")

    if ($commandName -eq 'Features') {
        $commandOutput += @("ShowInSidebar: false")
    }

    if ($commandName -eq 'Templates') {
        $commandOutput += @("ShowInSidebar: false")
    }

    $commandOutput += @("---")
    $commandOutput += @("import Xref from '@components/Xref.astro';$lineFeed")
    $commandOutput += @("{/* This file is automatically generated based on output from $($sourceCommands)/Chocolatey$($commandName)Command.cs using $($sourceLocation)GenerateDocs.ps1. Contributions are welcome at the original location(s). If the file is not found, it is not part of the open source edition of Chocolatey or the name of the file is different. */} $lineFeed")

    $commandOutput += $(& $chocoExe $commandName.ToLower() -h -r)
    $commandOutput += @("$lineFeed~~~$lineFeed$lineFeed<Xref title='Command Reference' value='choco-commands' classes='mb-3 d-block' />")
    $commandOutput += @("$lineFeed$lineFeed*NOTE:* This documentation has been automatically generated from ``choco $($commandName.ToLower()) -h``. $lineFeed")
    $fileContent = $commandOutput |
        ForEach-Object { Convert-CommandText $_ $commandName.ToLower() } |
        Out-String
    # Surround indented blocks with code blocks (intended for Usage and Examples sections), ignoring sections we are putting in code blocks in other ways
    $fileContent = $fileContent -replace '(\r?\n( {4}[^ <-].+\r?\n?)+)',"`r`n~~~`$0~~~`r`n`r`n"
    $fileContent | Out-File $fileName -Encoding UTF8 -Force
}

try {
    Write-Host "Importing the Module $psModuleName ..."
    Import-Module "$psModuleLocation" -Force -Verbose

    # Switch Get-PackageParameters back for documentation
    Remove-Item alias:Get-PackageParameters
    Remove-Item function:Get-PackageParametersBuiltIn
    Set-Alias -Name Get-PackageParametersBuiltIn -Value Get-PackageParameters -Scope Global

    if (Test-Path($docsFolder)) {
        Remove-Item $docsFolder -Force -Recurse -ErrorAction SilentlyContinue
    }
    if (-not(Test-Path $docsFolder)) {
        New-Item -ItemType Directory -Path $docsFolder -ErrorAction Continue | Out-Null
    }
    if (-not(Test-Path "$docsFolder\create\functions")) {
        New-Item -ItemType Directory -Path "$docsFolder\create\functions" -ErrorAction Continue | Out-Null
    }

    Write-Host 'Creating per PowerShell function markdown files...'
    $helperOrder = 10;
    Get-Command -Module $psModuleName -CommandType Function | ForEach-Object -Process { Get-Help $_ -Full } | ForEach-Object -Process { `
            $commandName = $_.Name
        $fileName = Join-Path "$docsFolder\create\functions" "$($_.Name.ToLower()).mdx"
        $global:powerShellReferenceTOC += "$lineFeed * <Xref title='$commandName' value='$([System.IO.Path]::GetFileNameWithoutExtension($fileName))' />"
        $hasCmdletBinding = (Get-Command -Name $commandName).CmdLetBinding

        Write-Host "Generating $fileName ..."
        $SplitName = $_.Name -split "-"
        $NameNoHyphen = $_.Name -replace '-', ''

        if ($_.Name -eq 'Get-OSArchitectureWidth') {
            $FormattedName = "get-os-architecture-width"
        }
        elseif ($_.Name -eq 'Get-UACEnabled') {
            $FormattedName = "get-uac-enabled"
        }
        else {
            $FormattedName = $SplitName[0].ToLower() + ($SplitName[1] -creplace '[A-Z]', '-$&').ToLower()
        }

        @"
---
order: $($helperOrder)
xref: $($_.Name.ToLower())
title: $($_.Name)
description: Information on $($_.Name) function
---
import Xref from '@components/Xref.astro';

# $($_.Name)

{/* This documentation is automatically generated from $sourceFunctions/$($_.Name)`.ps1 using $($sourceLocation)GenerateDocs.ps1. Contributions are welcome at the original location(s). */}

$(Replace-CommonItems $_.Synopsis)

## Syntax
$( ($_.syntax.syntaxItem | ForEach-Object { Convert-Syntax $_ $hasCmdletBinding }) -join "$lineFeed$lineFeed")
$( if ($_.description -ne $null) { $lineFeed + "## Description" + $lineFeed + $lineFeed + $(Replace-CommonItems $_.description.Text) })
$( if ($_.alertSet -ne $null) { $lineFeed + "## Notes" + $lineFeed + $lineFeed +  $(Replace-CommonItems $_.alertSet.alert.Text) })

## Aliases

$(Get-Aliases $_.Name)
$( if ($_.Examples -ne $null) { Write-Output "$lineFeed## Examples$lineFeed$lineFeed"; ($_.Examples.Example | ForEach-Object { Convert-Example $_ }) -join "$lineFeed$lineFeed"; Write-Output "$lineFeed" })
## Inputs

$( if ($_.InputTypes -ne $null -and $_.InputTypes.Length -gt 0 -and -not $_.InputTypes.Contains('inputType')) { $lineFeed + " * $($_.InputTypes)" + $lineFeed} else { 'None'})

## Outputs

$( if ($_.ReturnValues -ne $null -and $_.ReturnValues.Length -gt 0 -and -not $_.ReturnValues.StartsWith('returnValue')) { "$lineFeed * $($_.ReturnValues)$lineFeed"} else { 'None'})

## Parameters
$( if ($_.parameters.parameter.count -gt 0) { $_.parameters.parameter | ForEach-Object { Convert-Parameter $_ $commandName }}) $( if ($hasCmdletBinding) { "$lineFeed### &lt;CommonParameters&gt;$lineFeed$($lineFeed)This cmdlet supports the common parameters: -Verbose, -Debug, -ErrorAction, -ErrorVariable, -OutBuffer, and -OutVariable. For more information, see ``about_CommonParameters`` http://go.microsoft.com/fwlink/p/?LinkID=113216 ." } )

$( if ($_.relatedLinks -ne $null) {Write-Output "$lineFeed## Links$lineFeed$lineFeed"; $_.relatedLinks.navigationLink | Where-Object { $_.linkText -ne $null} | ForEach-Object { Write-Output "* <Xref title='$($_.LinkText)' value='$($_.LinkText.ToLower())' />$lineFeed" }})

<Xref title="Function Reference" value="powershell-reference" />

> :choco-info: **NOTE**
>
> This documentation has been automatically generated from ``Import-Module `"`$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1`" -Force; Get-Help $($_.Name) -Full``.

View the source for [$($_.Name)]($sourceFunctions/$($_.Name)`.ps1)
"@  | Out-File $fileName -Encoding UTF8 -Force
        $helperOrder = $helperOrder + 10
    }

    Write-Host "Generating Top Level PowerShell Reference"
    $fileName = Join-Path "$docsFolder\create\functions" 'index.mdx'

    $global:powerShellReferenceTOC += @'


## Chocolatey for Business Functions

* <Xref title="Install-ChocolateyWindowsService" value="install-chocolateywindowsservice" />
* <Xref title="Start-ChocolateyWindowsService" value="start-chocolateywindowsservice" />
* <Xref title="Stop-ChocolateyWindowsService" value="stop-chocolateywindowsservice" />
* <Xref title="Uninstall-ChocolateyWindowsService" value="uninstall-chocolateywindowsservice" />

## Variables

There are also a number of environment variables providing access to some values from the nuspec and other information that may be useful. They are accessed via `$env:variableName`.

### Environment Variables

Chocolatey makes a number of environment variables available (You can access any of these with $env:TheVariableNameBelow):

* TEMP/TMP - Overridden to the CacheLocation, but may be the same as the original TEMP folder
* ChocolateyInstall - Top level folder where Chocolatey is installed
* ChocolateyPackageName - The name of the package, equivalent to the `<id />` field in the nuspec
* ChocolateyPackageTitle - The title of the package, equivalent to the `<title />` field in the nuspec
* ChocolateyPackageVersion - The version of the package, equivalent to the `<version />` field in the nuspec

#### Advanced Environment Variables

The following are more advanced settings:

* ChocolateyPackageParameters - Parameters to use with packaging, not the same as install arguments (which are passed directly to the native installer). Based on `--package-parameters`.
* CHOCOLATEY_VERSION - The version of Choco you normally see. Use if you are 'lighting' things up based on choco version, otherwise take a dependency on the specific version you need.
* ChocolateyForceX86 = If available and set to 'true', then user has requested 32bit version. Automatically handled in built in Choco functions.
* OS_PLATFORM - Like Windows, macOS, Linux.
* OS_VERSION - The version of OS, like 6.1 something something for Windows.
* OS_NAME - The reported name of the OS.
* IS_PROCESSELEVATED = Is the process elevated?
* ChocolateyPackageInstallLocation - Install location of the software that the package installs. Displayed at the end of the package install.

#### Set By Options and Configuration

Some environment variables are set based on options that are passed, configuration and/or features that are turned on:

 * ChocolateyEnvironmentDebug - Was `--debug` passed? If using the built-in PowerShell host, this is always true (but only logs debug messages to console if `--debug` was passed)
 * ChocolateyEnvironmentVerbose - Was `--verbose` passed? If using the built-in PowerShell host, this is always true (but only logs verbose messages to console if `--verbose` was passed).
 * ChocolateyForce - Was `--force` passed?
 * ChocolateyForceX86 - Was `-x86` passed?
 * ChocolateyRequestTimeout - How long before a web request will time out. Set by config `webRequestTimeoutSeconds`
 * ChocolateyResponseTimeout - How long to wait for a download to complete? Set by config `commandExecutionTimeoutSeconds`
 * ChocolateyPowerShellHost - Are we using the built-in PowerShell host? Set by `--use-system-powershell` or the feature `powershellHost`

#### Business Edition Variables

 * ChocolateyInstallArgumentsSensitive - Encrypted arguments passed from command line `--install-arguments-sensitive` that are not logged anywhere.
 * ChocolateyPackageParametersSensitive - Package parameters passed from command line `--package-parameters-sensitive` that are not logged anywhere.
 * ChocolateyLicensedVersion - What version is the licensed edition on?
 * ChocolateyLicenseType - What edition / type of the licensed edition is installed?

#### Experimental Environment Variables

The following are experimental or use not recommended:

 * OS_IS64BIT = This may not return correctly - it may depend on the process the app is running under
 * CHOCOLATEY_VERSION_PRODUCT = the version of Choco that may match CHOCOLATEY_VERSION but may be different - based on git describe
 * IS_ADMIN = Is the user an administrator? But doesn't tell you if the process is elevated.

#### Not Useful Or Anti-Pattern If Used

 * ChocolateyInstallOverride - Not for use in package automation scripts. Based on `--override-arguments` being passed.
 * ChocolateyInstallArguments - The installer arguments meant for the native installer. You should use chocolateyPackageParameters instead. Based on `--install-arguments` being passed.
 * ChocolateyIgnoreChecksums - Was `--ignore-checksums` passed or the feature `checksumFiles` turned off?
 * ChocolateyAllowEmptyChecksums - Was `--allow-empty-checksums` passed or the feature `allowEmptyChecksums` turned on?
 * ChocolateyAllowEmptyChecksumsSecure - Was `--allow-empty-checksums-secure` passed or the feature `allowEmptyChecksumsSecure` turned on?
 * ChocolateyChecksum32 - Was `--download-checksum` passed?
 * ChocolateyChecksumType32 - Was `--download-checksum-type` passed?
 * ChocolateyChecksum64 - Was `--download-checksum-x64` passed?
 * ChocolateyChecksumType64 - Was `--download-checksum-type-x64` passed?
 * ChocolateyPackageExitCode - The exit code of the script that just ran - usually set by `Set-PowerShellExitCode`
 * ChocolateyLastPathUpdate - Set by Chocolatey as part of install, but not used for anything in particular in packaging.
 * ChocolateyProxyLocation - The explicit proxy location as set in the configuration `proxy`
 * ChocolateyDownloadCache - Use available download cache? Set by `--skip-download-cache`, `--use-download-cache`, or feature `downloadCache`
 * ChocolateyProxyBypassList - Explicitly set locations to ignore in configuration `proxyBypassList`
 * ChocolateyProxyBypassOnLocal - Should the proxy bypass on local connections? Set based on configuration `proxyBypassOnLocal`
 * http_proxy - Set by original `http_proxy` passthrough, or same as `ChocolateyProxyLocation` if explicitly set.
 * https_proxy - Set by original `https_proxy` passthrough, or same as `ChocolateyProxyLocation` if explicitly set.
 * no_proxy- Set by original `no_proxy` passthrough, or same as `ChocolateyProxyBypassList` if explicitly set.
 * ChocolateyPackageFolder - Not for use in package automation scripts. Recommend using `$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"` as per template generated by `choco new`
 * ChocolateyToolsLocation - Not for use in package automation scripts. Recommend using Get-ToolsLocation instead
'@

    $global:powerShellReferenceTOC | Out-File $fileName -Encoding UTF8 -Force

    Write-Host "Generating command reference markdown files"
    Generate-CommandReference 'Cache' '5'
    Generate-CommandReference 'Config' '10'
    Generate-CommandReference 'Download' '20'
    Generate-CommandReference 'Export' '30'
    Generate-CommandReference 'Find' '35'
    Generate-CommandReference 'Feature' '40'
    Generate-CommandReference 'Features' '45'
    Generate-CommandReference 'Help' '50'
    Generate-CommandReference 'Info' '60'
    Generate-CommandReference 'Install' '70'
    Generate-CommandReference 'List' '80'
    Generate-CommandReference 'Optimize' '90'
    Generate-CommandReference 'Outdated' '100'
    Generate-CommandReference 'Pin' '110'
    Generate-CommandReference 'Search' '120'
    Generate-CommandReference 'SetApiKey' '130'
    Generate-CommandReference 'Source' '140'
    Generate-CommandReference 'Sources' '150'
    Generate-CommandReference 'Support' '160'
    Generate-CommandReference 'Sync' '170'
    Generate-CommandReference 'Synchronize' '180'
    Generate-CommandReference 'Uninstall' '190'
    Generate-CommandReference 'UnpackSelf' '200'
    Generate-CommandReference 'Upgrade' '220'

    Generate-CommandReference 'New' '10'
    Generate-CommandReference 'Pack' '20'
    Generate-CommandReference 'ApiKey' '30'
    Generate-CommandReference 'Push' '40'
    Generate-CommandReference 'Template' '50'
    Generate-CommandReference 'Templates' '55'
    Generate-CommandReference 'Convert' '60'

    Generate-TopLevelCommandReference
    Move-GeneratedFiles

    Exit 0
}
catch {
    Throw "Failed to generate documentation.  $_"
    Exit 255
}
