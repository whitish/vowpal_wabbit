@ECHO OFF
IF DEFINED DebugBuildScripts (
    @ECHO ON
)

SETLOCAL

CALL %~dp0init.cmd

PUSHD %~dp0..

REM This is here to ensure that unless it is explicitly overriden we will generate a prerelease
REM "internal-only" package.
IF NOT DEFINED Version (
    REM Read version in from version.txt
    SET /P Version=<%vwRoot%\version.txt
)

IF NOT DEFINED Tag (
    SET Tag=-INTERNALONLY
)

SET RootRelativeOutputDirX64=%vwRoot%\vowpalwabbit\out\target\
SET RootRelativeOutputDirAnyCPU=%vwRoot%\vowpalwabbit\out\target\
SET SolutionDir=%vwRoot%\vowpalwabbit\
SET OutputDir="%SolutionDir%out\package\Release\x64"

IF NOT EXIST %OutputDir% MKDIR %OutputDir%

REM Do not add a trailing backslash here, as it will break the nuget xml parser for some reason
SET RepoRoot=%vwRoot%

REM TODO-pre-checkin: Figure out how to parametrize this script?! (is there a standard, or do we actually need parse args?)
"%nugetPath%" pack %SolutionDir%..\cs\cs\cs.nuspec -OutputDirectory "%OutputDir%" -Verbosity detailed -BasePath "." -Properties "RootRelativeOutputDirX64=%RootRelativeOutputDirX64%;RootRelativeOutputDirAnyCPU=%RootRelativeOutputDirAnyCPU%;Configuration=Release;Platform=X64;version=%Version%;Tag=%Tag%;RepoRoot=%RepoRoot%;SolutionDir=%SolutionDir%"
"%nugetPath%" pack %SolutionDir%..\cs\cs_json\cs_json.nuspec -OutputDirectory "%OutputDir%" -Verbosity detailed -BasePath "." -Properties "RootRelativeOutputDirX64=%RootRelativeOutputDirX64%;RootRelativeOutputDirAnyCPU=%RootRelativeOutputDirAnyCPU%;Configuration=Release;Platform=X64;version=%Version%;Tag=%Tag%;RepoRoot=%RepoRoot%;SolutionDir=%SolutionDir%"
"%nugetPath%" pack %SolutionDir%..\cs\cs_parallel\cs_parallel.nuspec -OutputDirectory "%OutputDir%" -Verbosity detailed -BasePath "." -Properties "RootRelativeOutputDirX64=%RootRelativeOutputDirX64%;RootRelativeOutputDirAnyCPU=%RootRelativeOutputDirAnyCPU%;Configuration=Release;Platform=X64;version=%Version%;Tag=%Tag%;RepoRoot=%RepoRoot%;SolutionDir=%SolutionDir%"

REM TODO: Need to also include the .pdb files, once we fix all the GitLink warnings

POPD

ENDLOCAL