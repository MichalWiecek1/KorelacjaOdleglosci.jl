using PkgTemplates
t = Template(;
user="MichalWiecek1",
authors="Michał Więcek, Igor Ciesielski, Kamil Burnecki, PWr",
julia=v"1.11.7",
plugins=[
License(; name="GPL-3.0-or-later"),
Git(; manifest=true),
GitHubActions(; x86=true),
Codecov(),
Documenter{GitHubActions}(),
Develop(),
],
)

t("KorelacjaOdległości")