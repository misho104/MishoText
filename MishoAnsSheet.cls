% Time-Stamp: <2024-07-03 17:00:00>
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{MishoAnsSheet}[2023/07/01 Sho Iwamoto]

\usepackage{luacode}
\begin{luacode*}
function unit(t)
  tex.sprint(t:sub(1, 1) == "/" and "" or "\\,", "\\mathrm{", t, "}\\xspace")
end
function removeLF(t)
  tex.print(({t:gsub("\\textLF.*", "")})[1])
end
\end{luacode*}
\def\IfEmpty#1#2#3{\if1\directlua{tex.sprint(\luastring{#1} == "" and "1")}\relax#2\else#3\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifmisho@cmyk
\newcount\misho@pdftype
\DeclareOption{10pt}{\def\misho@font@size{10pt}}
\DeclareOption{11pt}{\def\misho@font@size{11pt}}
\DeclareOption{12pt}{\def\misho@font@size{12pt}}
\DeclareOption{draft}{\def\misho@isdraft{draft}}
\DeclareOption{final}{\def\misho@isdraft{final}}
\DeclareOption{pdf0}{\misho@cmyktrue \misho@pdftype=0\def\misho@hropt{bookmarks=True}}
\DeclareOption{pdfx}{\misho@cmyktrue \misho@pdftype=1\def\misho@hropt{bookmarks=False}}
\DeclareOption{pdfa}{\misho@cmykfalse\misho@pdftype=2\def\misho@hropt{bookmarks=True}}
\DeclareOption{a4paper}{\def\misho@papersize{a4paper}}
\DeclareOption{a5paper}{\def\misho@papersize{a5paper}}

\newif\ifmisho@japanese\misho@japanesefalse
\DeclareOption{ja}\misho@japanesetrue
\DeclareOption{en}\misho@japanesefalse

\newif\ifmisho@lastpage\misho@lastpagefalse
\DeclareOption{lastpage}{\misho@lastpagetrue}

\ExecuteOptions{11pt,final,pdf0,en,a4paper}
\ProcessOptions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\pdfvariable omitcidset=1
\ifmisho@japanese
  \LoadClass[\misho@papersize,\misho@font@size,\misho@isdraft]{ltjsarticle}
  \usepackage{luatexja}
\else
  \LoadClass[\misho@papersize,\misho@font@size,\misho@isdraft]{article}
\fi

\usepackage[final,pdfversion=1.6,\misho@hropt]{hyperref}
\usepackage{hyperxmp}
\hypersetup{
  keeppdfinfo,     psdextra,       breaklinks=True, pdfborder=0 0 0,
  colorlinks=true, urlcolor=pBlue, linkcolor=pBlue, citecolor=pGreen}

\ifnum\misho@pdftype=1\relax%
  \dimen0=0.996264009963\paperwidth\relax
  \edef\pdfx@mwidth{\strip@pt\dimen0}%
  \advance\dimen0 -25\p@
  \edef\pdfx@twidth{\strip@pt\dimen0}%
  \dimen0=0.996264009963\paperheight\relax
  \edef\pdfx@mheight{\strip@pt\dimen0}%
  \advance\dimen0 -20\p@
  \edef\pdfx@theight{\strip@pt\dimen0}%
  \edef\mypdfpageattr{
    /MediaBox[0 0 \pdfx@mwidth\space \pdfx@mheight]^^J
    /BleedBox[0 0 \pdfx@mwidth\space \pdfx@mheight]^^J
    /CropBox[0 0 \pdfx@mwidth\space \pdfx@mheight]^^J
    /TrimBox[25 20 \pdfx@twidth\space \pdfx@theight]
  }
  \expandafter\pdfpageattr\expandafter{\mypdfpageattr}
  \immediate\pdfobj stream attr{/N 4} file{FOGRA39L_coated.icc}
  \pdfcatalog{%
    /OutputIntents [<<
      /Type /OutputIntent
      /S /GTS_PDFX
      /OutputCondition(FOGRA39L Coated)
      /OutputConditionIdentifier (Offset printing, according to ISO 12647-2:2004/Amd 1, OFCOM, paper type 1 or 2 = coated art, 115 g/m2, tone value increase curves A (CMY) and B (K))
      /DestOutputProfile \the\pdflastobj\space 0 R
      /RegistryName(http://www.fogra.org)
      /Info (FOGRA39L coated) >>]}
  \hypersetup{pdfxstandard={PDF/X-4},pdftrapped=True,pdfpagemode=UseNone,pdfstartview=}
  \global\def\hyper@linkfile#1#2#3{\Hy@colorlink\@filecolor#1\Hy@xspace@end}
  \global\def\hyper@linkurl#1#2{\Hy@colorlink\@urlcolor#1\endgroup\Hy@xspace@end}
  \global\def\hyper@linkstart#1#2#3{\Hy@colorlink\@linkcolor#3\endgroup\Hy@xspace@end}
  \global\let\hyper@linkend\relax
  \global\def\Hy@StartlinkName#1#2{}
  \global\def\close@pdflink{\Hy@VerboseLinkStop\Hy@endcolorlink}%
  \global\def\AcrobatMenu#1#2{#2}
\fi
\ifnum\misho@pdftype=2\relax%
  \immediate\pdfobj stream attr{/N 3} file{sRGB.icc}
  \pdfcatalog{%
    /OutputIntents [<<
      /Type /OutputIntent
      /S /GTS_PDFA1
      /DestOutputProfile \the\pdflastobj\space 0 R
      /OutputConditionIdentifier (sRGB)
      /Info (sRGB) >>]}
  \hypersetup{pdfapart=2,pdfaconformance=u,pdftrapped=True}
\fi

\ifmisho@cmyk
  \usepackage[cmyk]{xcolor}
\else
  \usepackage[rgb]{xcolor}
\fi

\def\title@cr{}
\def\title@ce{}
\def\title@cu{}
\def\title@lu{}
\define@key{Hyp}{pdfcopyright}{\hyxmp@pdfstringdef\@pdfcopyright{#1}\def\title@cr{\directlua{removeLF(\luastringN{#1})}}}
\define@key{Hyp}{pdfcontactemail}{\hyxmp@pdfstringdef\@pdfcontactemail{#1}\def\title@ce{#1}}
\define@key{Hyp}{pdfcontacturl}{\hyxmp@pdfstringdef\@pdfcontacturl{#1}\def\title@cu{#1}}
\define@key{Hyp}{pdflicenseurl}{\hyxmp@pdfstringdef\@pdflicenseurl{#1}\def\title@lu{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\automatichyphenmode=1
\def\misho@font@english{STIXTwoText}
\def\misho@font@sf{Roboto}
\def\misho@font@tt{Roboto Mono}
\def\misho@font@ja  {HaranoAjiMincho-Regular.otf}
\def\misho@font@jabf{HaranoAjiGothic-Bold.otf}
\def\misho@font@jasf{HaranoAjiGothic-Regular.otf}
%\def\misho@font@math{latinmodern-math.otf}
\def\misho@font@math{STIXTwoMath-Regular.otf}

\usepackage[quiet]{fontspec}
\newfontfamily{\englishfont}[Ligatures={TeX}]{\misho@font@english}
\newfontfamily{\englishfontsf}[Scale=0.91]{\misho@font@sf}
\newfontfamily{\englishfonttt}[Scale=0.85]{\misho@font@tt}
\newfontfamily{\japanesefont}  [BoldFont=\misho@font@jabf,ItalicFont=\misho@font@ja,  ItalicFeatures={FakeSlant}]{\misho@font@ja}
\newfontfamily{\japanesefontsf}[BoldFont=\misho@font@jabf,ItalicFont=\misho@font@jasf,ItalicFeatures={FakeSlant}]{\misho@font@jasf}
\newfontfamily{\japanesefonttt}[BoldFont=\misho@font@jabf,ItalicFont=\misho@font@jasf,ItalicFeatures={FakeSlant}]{\misho@font@jasf}
% Polyglossia must be loaded after newfontfamily (/ -> 2215 bug)
\usepackage[luatexrenderer=OpenType]{polyglossia}
    % no particular reason to avoid Harfbuzz
\ifmisho@japanese
  \setdefaultlanguage{japanese}
  \setotherlanguages{english}
  \setmainfont[BoldFont=\misho@font@jabf,ItalicFont=\misho@font@ja,  ItalicFeatures={FakeSlant}]{\misho@font@ja}
  \setsansfont[BoldFont=\misho@font@jabf,ItalicFont=\misho@font@jasf,ItalicFeatures={FakeSlant}]{\misho@font@jasf}
  \setmonofont[BoldFont=\misho@font@jabf,ItalicFont=\misho@font@jasf,ItalicFeatures={FakeSlant}]{\misho@font@jasf}
\else
  \setdefaultlanguage[variant=us]{english}
  \setotherlanguage{japanese}
  \setmainfont[Ligatures={TeX}]{\misho@font@english}
  \setsansfont[Scale=0.91]{\misho@font@sf}
  \setmonofont[Scale=0.85]{\misho@font@tt}
\fi

% MathFont setting copied from MySlideFont.sty
  \usepackage{unicode-math}
  \ExplSyntaxOn
    \bool_gset_false:N \g__um_bfliteral_bool
    \bool_gset_true:N  \g__um_bfupGreek_bool
    \bool_gset_false:N \g__um_bfupgreek_bool
    \bool_gset_false:N \g__um_bfupLatin_bool
    \bool_gset_false:N \g__um_bfuplatin_bool
    \bool_gset_false:N \g__um_mathrm_text_bool % I understand their philosophy
    \bool_gset_false:N \g__um_mathit_text_bool % but still not use it for an
    \bool_gset_false:N \g__um_mathbf_text_bool % inconsistency in greek.
    \bool_gset_false:N \g__um_mathsf_text_bool
    \bool_gset_false:N \g__um_mathtt_text_bool
  \ExplSyntaxOff
  \setmathfont{\misho@font@math}
  \setoperatorfont\mathrm

  % fine tuning of some letters
  % https://tex.stackexchange.com/questions/364310/
  \setmathfont{latinmodern-math.otf}[range={\mupUpsilon,\mitUpsilon,\mbfUpsilon,\mbfitUpsilon}]
  \setmathfont{texgyreschola-math.otf}[range={\hat,\tilde,\bar}]
  \setmathfont{\misho@font@math}[range=\int]
  \AtBeginDocument{\renewcommand*\Upsilon{\mupUpsilon}}

% Language Shortcuts
\let\JA\relax
\let\EN\relax
\ifmisho@japanese
  \def\EN#1{{\english{#1}\endenglish}}
\else
  \def\JA#1{{\japanese{#1}\endjapanese}}
\fi

% Logical fonts
\ifmisho@japanese
  \relax
\else
  \newcommand*{\headfont}{\normalcolor\sffamily}
\fi

% More math fonts (but not ever used)
% \usepackage{wasysym}
% yhmath is INCOMPATIBLE!
%\DeclareSymbolFont{yhlargesymbols}{OMX}{yhex}{m}{n}
%\DeclareMathAccent{\yhwidehat}{\mathord}{yhlargesymbols}{"62}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand*\@convertto[2]{\strip@pt\dimexpr #2*65536/\number\dimexpr 1#1}
\newcommand*\ShowLength[1]{\@convertto{em}{#1}em = \@convertto{mm}{#1}mm = \@convertto{pt}{#1}pt} % for debugging
\ExplSyntaxOn
\str_if_eq:VnTF{\misho@papersize}{a4paper}{
  \setlength\textwidth{160mm}  % 25mm margin
  \setlength\textheight{237mm}  % 30mm margin
}{
  \setlength\textwidth{118.5mm}  % 12mm margin
  \setlength\textheight{180mm}  % 15mm margin
}
\ExplSyntaxOff
\setlength\headheight{18pt}
\setlength\headsep{16pt}

\newdimen\@tempdima
\newdimen\@total@leftsep
\newdimen\@total@headsep

\@tempdima\paperheight
\advance\@tempdima -\textheight
\divide\@tempdima by 2
\@total@headsep\@tempdima

\advance\@tempdima -\headheight
\advance\@tempdima -\headsep
\advance\@tempdima -1in % the one-inch
\topmargin\@tempdima

\@tempdima\paperwidth
\advance\@tempdima -\textwidth
\divide\@tempdima by 2
\@total@leftsep\@tempdima
\advance\@tempdima -1in % the one-inch
\oddsidemargin\@tempdima\relax
\evensidemargin\oddsidemargin\relax

% baselineskip = 1.242em = 4.77988mm
\parskip=0mm plus .5mm
\parsep=1mm plus .5mm minus 1mm

\abovedisplayskip=12pt plus 3pt minus 9pt
\belowdisplayskip=12pt plus 3pt minus 9pt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\usepackage[hhmmss]{datetime}
\newdateformat{mydate}{\THEDAY-\shortmonthname-\THEYEAR}

%\newdimen\head@colwidth
%\head@colwidth\textwidth
%\advance\head@colwidth -11em % for datetime region
%\divide\head@colwidth by 2

\def\leftmark{\expandafter\@leftmark\firstmark\@empty\@empty}
\def\rightmark{\expandafter\@rightmark\botmark\@empty\@empty}

\def\head@hrule{\lower1mm\null\vadjust{{\color{lightgray}\hrule height .7mm}\vskip-2mm}}
\def\head@h{\ifnum \c@secnumdepth >\z@ \leftmark\fi}
\def\head@j{\mydate\today~\currenttime}
\ifmisho@lastpage
  \usepackage{lastpage}
  \def\head@p{\thepage/\NoHyper\pageref{LastPage}\endNoHyper}
\else
  \def\head@p{\thepage}
\fi

\def\head@hstyle{\fontsize{9}{12}\selectfont\color{lightgray}\sffamily}
\def\head@jstyle{\fontsize{9}{12}\selectfont\color{dimgray}\ttfamily}
\def\head@pstyle{\fontsize{12}{12}\selectfont\sffamily\bfseries}
\def\ps@plain{%
  \def\@evenfoot{} % {\reset@font\hfil\thepage\hfil}
  \let\@oddfoot\@evenfoot
  \def\@evenhead{%
    \kern2mm{\head@hstyle{\head@h}}\hfil{\head@jstyle{\head@j}}%
    \makebox[3em][r]{\head@pstyle\head@p}\kern2mm%
    \aftergroup\head@hrule}%
  \let\@oddhead\@evenhead
}
\AtBeginDocument{
  \markboth{\@title}{\relax}
}
\def\sectionmark#1{\markright{\ifnum \c@secnumdepth >\z@ %
  {\thesection}\hskip1em
\fi #1}}%
\pagestyle{empty}

\newcommand\SetHead[2]{\expandafter\gdef\csname head@#1\endcsname{#2}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\TopLRBox#1#2{\begin{tikzpicture}[remember picture,overlay]%
  \node[xshift=8mm,yshift=-8mm,anchor=north west] at (current page.north west){#1};%
  \node[xshift=-8mm,yshift=-8mm,anchor=north east] at (current page.north east){#2};%
\end{tikzpicture}\relax}

\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\headfont\Large\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\headfont\large\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\headfont\normalsize\bfseries}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {2\parsep}%
                                    {-1em}%
                                    {\headfont\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {2\parsep}%
                                       {-1em}%
                                      {\headfont\normalsize\bfseries}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\definecolor{gray}         {gray}{0.5}
\definecolor{lightgray}    {gray}{0.8}
\definecolor{dimgray}      {gray}{0.9}
\ifmisho@cmyk  % CMYK
  \definecolor{pBlue}        {cmyk}{0.894,0.688,0.000,0} % #0e51c9
  \definecolor{pPink}        {cmyk}{0.000,0.834,0.000,0} % #ff45a0
  \definecolor{pGreen}       {cmyk}{0.782,0.314,1.000,0} % #348d1b
  \definecolor{pLightOrange} {cmyk}{0.000,0.223,0.419,0} % #ffd69d
  \definecolor{pLightPurple} {cmyk}{0.452,0.580,0.000,0} % #aa78d6
  \definecolor{pLightGreen}  {cmyk}{0.570,0.000,0.374,0} % #00ffd0
  \definecolor{AltDefA}      {cmyk}{0.000,0.892,0.946,0}
  \definecolor{AltDefB}      {cmyk}{0.911,0.788,0.000,0} % but not to abuse
\else          % RGB
  \definecolor{pBlue}        {rgb}{0.0549,0.3176,0.7882} % #0e51c9
  \definecolor{pPink}        {rgb}{1.0000,0.2706,0.6275} % #ff45a0
  \definecolor{pGreen}       {rgb}{0.2039,0.5529,0.1059} % #348d1b
  \definecolor{pLightOrange} {rgb}{1.0000,0.8392,0.6157} % #ffd69d
  \definecolor{pLightPurple} {rgb}{0.6667,0.4706,0.8392} % #aa78d6
  \definecolor{pLightGreen}  {rgb}{0.0000,1.0000,0.8157} % #00ffd0
  \definecolor{AltDefA}      {rgb}{1.0000,0.2000,0.0000}
  \definecolor{AltDefB}      {rgb}{0.1500,0.5000,0.7000} % but not to abuse
\fi
% these are color command but should be considered as emphasize commands
\newcommand\@colored[2]{{\color{#1}#2}}
\newcommand\GRAY {\@colored{gray}}
\newcommand\BLUE {\@colored{pBlue}}
\newcommand\PINK {\@colored{pPink}}
\newcommand\GREEN{\@colored{pGreen}}
\newcommand\RED  {\@colored{AltDefA}}
\newcommand\C    {\@ifstar{\@colored{AltDefB}}{\@colored{AltDefA}}}

\let\misho@C\C
%\def\C#1{\@ifnextchar_{\misho@C@d{#1}}{\misho@C@x{#1}}}
%\def\misho@C@d#1_#2{\@ifnextchar^{\misho@C@du#1_#2}{\misho@C{{#1}_{#2}}}}
%\def\misho@C@du#1_#2^#3{\misho@C{{#1}_{#2}^{#3}}}
%\def\misho@C@x#1{\@ifnextchar^{\misho@C@u{#1}}{\misho@C{#1}}}
%\def\misho@C@u#1^#2{\@ifnextchar_{\misho@C@ud#1^#2}{\misho@C{{#1}^{#2}}}}
%\def\misho@C@ud#1^#2_#3{\misho@C{{#1}^{#2}_{#3}}}
%\def\C#1{\@ifnextchar_{\misho@C@d{#1}}{\@ifnextchar'{\misho@C@p{#1}}{\misho@C@x{#1}}}}
%\def\misho@C@d#1_#2{\@ifnextchar^{\misho@C@du#1_#2}{\misho@C{{#1}_{#2}}}}
%\def\misho@C@du#1_#2^#3{\misho@C{{#1}_{#2}^{#3}}}
%\def\misho@C@x#1{\@ifnextchar^{\misho@C@u{#1}}{\misho@C{#1}}}
%\def\misho@C@u#1^#2{\@ifnextchar_{\misho@C@ud#1^#2}{\misho@C{{#1}^{#2}}}}
%\def\misho@C@ud#1^#2_#3{\misho@C{{#1}^{#2}_{#3}}}
%\def\misho@C@p#1'{\@ifnextchar_{\misho@C@pd#1'}{\misho@C{#1'}}}
%\def\misho@C@pd#1'_#2{\misho@C{#1'_{#2}}}
\def\C#1{\@ifnextchar_{\misho@C@d{#1}}{\@ifnextchar'{\misho@C@p{#1}}{\misho@C@x{#1}}}}
\def\misho@C@d#1_#2{\@ifnextchar^{\misho@C@du#1_#2}{\misho@C{#1}_{\misho@C{#2}}}}
\def\misho@C@du#1_#2^#3{\misho@C{#1}_{\misho@C{#2}}^{#3}}
\def\misho@C@x#1{\@ifnextchar^{\misho@C@u{#1}}{\misho@C{#1}}}
\def\misho@C@u#1^#2{\@ifnextchar_{\misho@C@ud#1^#2}{\misho@C{#1}^{#2}}}
\def\misho@C@ud#1^#2_#3{\misho@C{#1}^{#2}_{\misho@C{#3}}}
\def\misho@C@p#1'{\@ifnextchar_{\misho@C@pd#1'}{\misho@C{#1'}}}
\def\misho@C@pd#1'_#2{\misho@C{#1'_{#2}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% https://tex.stackexchange.com/questions/175251/
\newcommand*\RedeclareMathOperator{%
  \@ifstar{\def\rmo@s{m}\rmo@redeclare}{\def\rmo@s{o}\rmo@redeclare}%
}
\newcommand*\rmo@redeclare[2]{%
  \begingroup \escapechar\m@ne\xdef\@gtempa{{\string#1}}\endgroup
  \expandafter\@ifundefined\@gtempa
     {\@latex@error{\noexpand#1undefined}\@ehc}%
     \relax
  \expandafter\rmo@declmathop\rmo@s{#1}{#2}}
\newcommand*\rmo@declmathop[3]{%
  \DeclareRobustCommand{#2}{\qopname\newmcodes@#1{#3}}%
}

\newcommand*\ii{{\mathrm{i}}}
\newcommand*\ee{{\mathrm{e}}}
\newcommand*\dd{{\mathrm{d}}}
\newcommand*\DD{{\mathrm{D}}}
\newcommand*\TT{{\mathrm{T}}}
\newcommand*\cc{{\mathrm{c}}}
\newcommand*\NN{{\mathbb{N}}}
\newcommand*\ZZ{{\mathbb{Z}}}
\newcommand*\RR{{\mathbb{R}}}
\newcommand*\CC{{\mathbb{C}}}
\newcommand*\KK{{\mathbb{K}}}
\newcommand*\GG{{\mathbb{G}}}

\newcommand*\vep{\varepsilon} % \vep^{12} = \vep^{0123} = 1 but \vep_{12} = \vep_{0123} = -1.
\newcommand*\nep{\epsilon}    % to distinguish from vep:  \nep^{12} = \nep_{12} = +1.

\newcommand*\vc[1]{{\mathbf{#1}}}
\newcommand*\vipro[2]{\vc{#1}\cdot\vc{#2}}
\newcommand*\vopro[2]{\vc{#1}\times\vc{#2}}

\NewDocumentCommand\w  {sm}{\IfBooleanTF{#1}{_{\text{#2}}}{_{\mathrm{#2}}}}
\NewDocumentCommand\wup{sm}{\IfBooleanTF{#1}{^{\text{#2}}}{^{\mathrm{#2}}}}

\NewDocumentCommand\abs  {sm}{\IfBooleanTF{#1}{\left\lvert#2\right\rvert}{\lvert#2\rvert}}
\NewDocumentCommand\norm {sm}{\IfBooleanTF{#1}{\left\lVert#2\right\rVert}{\lVert#2\rVert}}
\NewDocumentCommand\vnorm{sm}{\IfBooleanTF{#1}{\left\lVert\vc{#2}\right\rVert}{\lVert\vc{#2}\rVert}}
\NewDocumentCommand\mean {sm}{\IfBooleanTF{#1}{\left\langle#2\right\rangle}{\langle#2\rangle}}

\NewDocumentCommand\then{s}{\IfBooleanTF{#1}{\quad\Longrightarrow\quad}{\hskip.5em\Longrightarrow\hskip.5em}}

\newcommand*{\wdiag}{^{\text{diag}}}

\newcommand\co[1]{\mathrm{c}_{#1}}
\newcommand\si[1]{\mathrm{s}_{#1}}
\newcommand\ta[1]{\mathrm{t}_{#1}}
\newcommand\coco[1]{\mathrm{c}^2_{#1}}
\newcommand\sisi[1]{\mathrm{s}^2_{#1}}

\AtBeginDocument{
  \RedeclareMathOperator{\Re} {\mathrm{Re}}
  \RedeclareMathOperator{\Im} {\mathrm{Im}}
}
\DeclareMathOperator{\arctanh}{\mathrm{arctanh}}
\DeclareMathOperator{\arccoth}{\mathrm{arccoth}}
\DeclareMathOperator{\arcsinh}{\mathrm{arcsinh}}
\DeclareMathOperator{\arccosh}{\mathrm{arccosh}}
\DeclareMathOperator{\sech}   {\mathrm{sech}}
\DeclareMathOperator{\csch}   {\mathrm{csch}}
\DeclareMathOperator{\Tr}     {\mathrm{Tr}}
\DeclareMathOperator{\rank}   {\mathrm{rank}}
\DeclareMathOperator{\diag}   {\mathrm{diag}}
\DeclareMathOperator{\ad}     {\mathrm{ad}}
\DeclareMathOperator{\Order}  {\symcal{O}}
\DeclareMathOperator{\sign}   {\mathrm{sign}}
\DeclareMathOperator{\Br}     {\mathrm{Br}}
\newcommand*\defeq{\coloneq}

\newcommand*\EE{\@ifnextchar-{\@@EE}{\@EE}}
\newcommand*\@EE[1]{\ifnum#1=1 \times\!10 \else \times\!10^{#1}\fi}
\newcommand*\@@EE[2]{\times\!10^{-#2}}

\NewDocumentCommand\pfrac{omm}{\left(\frac{#2}{#3}\right)\IfValueT{#1}{^#1}}
\NewDocumentCommand\gdiff{O{\dd}omm}{\IfValueTF{#2}{\frac{#1^#2#3}{#1#4^#2}}{\frac{#1#3}{#1#4}}}
\NewDocumentCommand\diff{omm}{\gdiff[\dd][#1]{#2}{#3}}
\NewDocumentCommand\pdiff{omm}{\gdiff[\partial][#1]{#2}{#3}}

\newcommand*\diracdelta[1][]{\qopname\relax o{\ifx\\#1\\\mathrm{\delta}\else\mathrm{\delta}^{(#1)}\fi}}
\newcommand*\Kallen    [1][]{\qopname\relax o{\ifx\\#1\\\mathrm{\lambda}\else\mathrm{\lambda}^{#1}\fi}}

\newcommand*\pmat[1]{\begin{pmatrix}#1\end{pmatrix}}
\newcommand*\spmat[1]{\left(\begin{smallmatrix}#1\end{smallmatrix}\right)}

\newcommand\unit[1]{\directlua{unit(\luastring{#1})}}
\newcommand\eV {\unit{eV}}
\newcommand\keV{\unit{keV}}
\newcommand\MeV{\unit{MeV}}
\newcommand\GeV{\unit{GeV}}
\newcommand\TeV{\unit{TeV}}
\newcommand\PeV{\unit{PeV}}
\newcommand\fb {\unit{fb}}
\newcommand\pb {\unit{pb}}
\newcommand\iab{\unit{ab^{-1}}}
\newcommand\ifb{\unit{fb^{-1}}}
\newcommand\ipb{\unit{pb^{-1}}}
\newcommand\fm {\unit{fm}}

\renewcommand\leadsto{\mathrel{\rightdasharrow}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\usepackage{subcaption,booktabs,wrapfig,slashed,xspace,braket,cancel,amsmath}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\usepackage[capitalize,english]{cleveref}

\renewcommand\thefootnote{*\arabic{footnote}}
\numberwithin{equation}{section}

\urlstyle{englishfonttt}
\DeclareTextFontCommand{\textbfsf}{\bfseries\sffamily}
\DeclareRobustCommand{\Emph}{\@ifstar\textbfsf\textbf}

\newcommand\package[2][\relax]{\texttt{#2}\ifx#1\relax\relax\else~\texttt{#1}\fi}

\newcommand{\TODO}[1]{\RED{$\spadesuit$\texttt{TODO:}#1$\spadesuit$}}
\newcommand{\TOCHECK}[1][needs proofreeding]{\RED{$\spadesuit$#1$\spadesuit$}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% `answerbox.sty' Copyright (C) 2017-2022 by hohei.
% \ProvidesPackage{answerbox}[2021/11/14, v1.50]
\RequirePackage{tikz}
\usetikzlibrary{calc,positioning}
\RequirePackage{etoolbox,xkeyval}
\RequirePackage{xcolor}

% 単位(pt)を取る
\newdimen\zero\relax
\zero=0pt
\begingroup
  \catcode`P=12
  \catcode`T=12
  \lowercase{%
    \def\x{\def\rempt##1.##2PT{##1\ifnum##2>\zero.##2\fi}}}
  \expandafter\endgroup\x

\def\strippt{\expandafter\rempt\the}

% 大問番号
\newcounter{daimon@bangou}
\setcounter{daimon@bangou}{0}

% 太さの定義
\def\@FUTOSA#1{%
  \ifcase#1 \or 0.1\p@\or 0.2\p@\or 0.4\p@\or 0.6\p@\or 0.8\p@\or 1.2\p@\or 1.6\p@\or 2.0\p@\or 2.4\p@\or 2.8\p@\fi}


% 箱の太さの変更
% 太さの関数
\newcommand{\box@thickness}[1]{%
\@cotA=0
\@cotB=0
%
  \@futosa=\@FUTOSA{#1}
%
  \@cotA=#1
  \advance\@cotA by 1
  \ifnum\@cotA>10
    \@Dfutosa=\@FUTOSA{10}
  \else
    \@Dfutosa=\@FUTOSA{\@cotA}% 大問の太さ
  \fi
%
  \@cotB=#1
  \advance\@cotB by -1
  \ifnum\@cotB<1
    \@Hfutosa=\@FUTOSA{1}
  \else
    \@Hfutosa=\@FUTOSA{\@cotB}% 破線の太さ
  \fi
}%

  \newcount\@cotA
  \newcount\@cotB
  \newcount\@cotC
  \newcount\@cotD
  \newcount\@cotX
  \newcount\@cotY
  \newdimen\@dimA
  \newdimen\@dimB
  \newdimen\@dimX
% 小問の箱の番号の部分を除いた，セル1つ分の長さ
  \newdimen\haba@shoumon
% 小問番号
  \newcounter{shoumon@bangou}
  \setcounter{shoumon@bangou}{0}
% セルの分割数
  \newcount\bangouA
  \bangouA=1
  \newcount\@bangouB
  \@bangouB=0
% 箱の頂点のy座標
  \newdimen\@choutenA
  \newdimen\@choutenB
  \@choutenA=0mm
  \@choutenB=0mm
% 大問の箱の頂点のy座標
  \newdimen\@DchoutenA
  \@DchoutenA=0mm
% 箱の幅
  \newdimen\@haba
  \newdimen\@habaA
% 大問と小問の距離，大問番号の幅
  \newdimen\@SDspace% xkeyvalで定義
  \newdimen\@Dwidth% xkeyvalで定義
% 小問番号の幅
  \newdimen\@Swidth% xkeyvalで定義
  \newdimen\temp@Swidth%
  \newdimen\tempX@Swidth%
  \newdimen\tempY@Swidth%
% 太さの値
  \newdimen\@futosa
  \newdimen\@Dfutosa% 大問の太さ
  \newdimen\@Hfutosa% 破線の太さ

% 箱の高さ
  \newdimen\@takasa% xkeyvalで定義
  \newdimen\temp@takasa% xkeyvalで定義
  \newdimen\tempX@takasa%
  \newdimen\tempY@takasa%
% ansboxesとansboxの分岐
  \newcount\@BUNKI
  \@BUNKI=0
% 箱の太さ
  \newcount\box@thickness@value% 太さの値
  \newcount\temp@box@thickness@value% 太さの値
  \newcount\tempX@box@thickness@value
  \newcount\tempY@box@thickness@value
% 箱の幅
  \newdimen\box@scale
  % \box@scale=1.0pt% 1倍だと飛び出ると警告
  \newdimen\temp@box@scale
  \newdimen\tempX@box@scale
  \newdimen\tempY@box@scale
% 次の箱までの間隔
  \newdimen\@boxspace% xkeyvalで定義
  \def\@BOXSPACE{\@boxspace plus 0.2\@boxspace minus 0.2\@boxspace}
  \newdimen\temp@boxspace% xkeyvalで定義
  % \newdimen\tempX@boxspace%
  % \newdimen\tempY@boxspace%

% default 値
  \@takasa=16mm
  \box@scale=1.0\p@
  \box@thickness@value=4
  \box@thickness{\box@thickness@value}
  \@boxspace=2.0mm
  \@SDspace=1mm
  \@Dwidth=6.0mm
  \@Swidth=5.0mm

% xkeyval による定義
  \define@key{box}{height}{\@takasa=#1}
  \define@key{box}{scale}{\box@scale=#1\p@}
  \setkeys{box}{scale=1.0}
  \define@key{box}{thickness}{\box@thickness@value=#1 \box@thickness{\box@thickness@value}}
  \define@key{box}{space}{\@boxspace=#1}
  \define@key{box}{SDspace}{\@SDspace=#1}
  \define@key{box}{Dwidth}{\@Dwidth=#1}
  \define@key{box}{Swidth}{\@Swidth=#1}

\newcommand{\answerbox}[1]{\setkeys{box}{#1}}


  \def\ptxt{\@ifstar{\put@textbox}{\put@text}}

\newcount\ptxt@BUNKI
\ptxt@BUNKI=1

\newcommand{\put@text}[4][]{%
\ifnum\ptxt@BUNKI=1
  \draw (P#2) node[#1] {\makebox[\haba@shoumon][#3]{#4}};
\fi%
}

\newcommand{\ptxttoggle}{%
\ifnum\ptxt@BUNKI=1
  \ptxt@BUNKI=0
\else
  \ptxt@BUNKI=1
\fi%
}

\newcommand{\zeroFCOLORBOX}[1]{%
  \newdimen\zerofb@xsep
  \newdimen\zerofb@xrule
  \zerofb@xsep=\fboxsep
  \zerofb@xrule=\fboxrule
  \fboxsep=0\p@
  \fboxrule=4\fboxrule
  \fcolorbox{red}{yellow}{#1}
  \fboxsep=\zerofb@xsep
  \fboxrule=\zerofb@xrule
}

\newcommand{\put@textbox}[4][]{%
\ifnum\ptxt@BUNKI=1
  \draw (P#2) node[#1] {\zeroFCOLORBOX{\makebox[\haba@shoumon][#3]{#4}}};
\fi
}

% 環境の変数
  \define@key{envbox}{height}{\@takasa=#1}
  \define@key{envbox}{space}{\@boxspace=#1}
  \define@key{envbox}{SDspace}{\@SDspace=#1}
  \define@key{envbox}{Dwidth}{\@Dwidth=#1}
  \define@key{envbox}{Swidth}{\@Swidth=#1}
  \define@key{envbox}{daimon}{
      \setcounter{daimon@bangou}{#1}
      \addtocounter{daimon@bangou}{-1}
}
  \define@key{envbox}{shoumon}{
    \setcounter{shoumon@bangou}{#1}
    \addtocounter{shoumon@bangou}{-1}
}
  \define@key{envbox}{scale}{\box@scale=#1\box@scale}
  \define@key{envbox}{thickness}{%
    \box@thickness@value=#1%
    \box@thickness{\box@thickness@value}
  }

\newenvironment{ansbox}[1][%
     scale=1.0
]{%
\temp@box@scale=\box@scale
\temp@takasa=\@takasa
\temp@Swidth=\@Swidth
\temp@box@thickness@value=\box@thickness@value
\box@thickness{\temp@box@thickness@value}
\temp@boxspace=\@boxspace

\setkeys{envbox}{#1}
%
% 箱全体の横幅
  \@habaA=\the\columnwidth\relax
  \@habaA=0.98\@habaA\relax% ラインオーバー警告対策
% 大問と小問のスペースだけ短くする
  \advance\@habaA by -\@SDspace
  \advance\@habaA by -\@Dwidth
%
  \noindent
  \begin{tikzpicture}%
}%
{%
  \setcounter{shoumon@bangou}{0}
  \stepcounter{daimon@bangou}
% 大問番号の枠
  \draw[line width=\@Dfutosa] ({-\@Dwidth-\@SDspace},-\@DchoutenA) rectangle (-\@SDspace,-\@choutenB);
  \draw ({-0.5*\@Dwidth-\@SDspace},{0.5*(-\@DchoutenA-\@choutenB)}) node[] {\thedaimon@bangou};
  \end{tikzpicture}%
\vskip\@BOXSPACE\relax
%
% 値の引き継ぎ
\@boxspace=\temp@boxspace
\@takasa=\temp@takasa
\@Swidth=\temp@Swidth
\box@thickness@value=\temp@box@thickness@value
\box@thickness{\box@thickness@value}

\box@scale=\temp@box@scale
}

% 大問の非表示版
\newenvironment{ansbox*}[1][%
     scale=1.0
]{%
\temp@box@scale=\box@scale
\temp@takasa=\@takasa
\temp@Swidth=\@Swidth
\temp@box@thickness@value=\box@thickness@value
\box@thickness{\temp@box@thickness@value}
\temp@boxspace=\@boxspace

\setkeys{envbox}{#1}
% 箱全体の横幅
  \@habaA=\the\columnwidth\relax
  \@habaA=0.98\@habaA\relax% ラインオーバー警告対策
  \noindent
  \begin{tikzpicture}%
}%
{%
  \end{tikzpicture}%
  \vskip\@BOXSPACE\relax
%
% 値の引き継ぎ
\@boxspace=\temp@boxspace
\@takasa=\temp@takasa
\@Swidth=\temp@Swidth
\box@thickness@value=\temp@box@thickness@value
\box@thickness{\box@thickness@value}
\box@scale=\temp@box@scale
}

  \def\pbox{\@ifstar{\@putboxstar}{\@putbox}}
  \def\@putboxstar{\@ifnextchar[{\@funcX}{\@funcY}}
  \def\@funcX[#1]#2{\@ifnextchar[{\@funcW[#1]#2}{\@PUTBOXESstar{#2}{#1}}}% (2021/08/29)
  \def\@funcW[#1]#2[#3]{\@PUTBOXESstar[#3]{#2}{#1}}% (2021/08/29)
  \def\@funcY#1{\@ifnextchar[{\@funcZ#1}{\@PUTBOXstar{#1}}}
  \def\@funcZ#1[#2]{\@PUTBOXstar[#2]{#1}}
  \def\@putbox{\@ifnextchar[{\@funcA}{\@funcB}}
  \def\@funcA[#1]#2{\@ifnextchar[{\@funcD[#1]#2}{\@PUTBOXES{#2}{#1}}}% (2021/08/29)
  \def\@funcD[#1]#2[#3]{\@PUTBOXES[#3]{#2}{#1}}% (2021/08/29)
  \def\@funcB#1{\@ifnextchar[{\@funcC#1}{\@PUTBOX{#1}}}
  \def\@funcC#1[#2]{\@PUTBOX[#2]{#1}}% (2021/08/29)

% putboxesの引数
  \define@key{putboxes}{height}{\@takasa=#1}
  \define@key{putboxes}{thickness}{\temp@box@thickness@value=#1 \box@thickness{#1}}
  \define@key{putboxes}{shoumon}{
    \setcounter{shoumon@bangou}{#1}
    \addtocounter{shoumon@bangou}{-1}
}
  \define@key{putboxes}{scale}{\tempX@box@scale=#1\temp@box@scale}
  \define@key{putboxes}{Swidth}{\@Swidth=#1}

\newcommand{\@PUTBOXES}[3][%
    scale=1.0
]{%
\@cotA=0
\@cotB=0
\@cotC=0
\@cotD=0
\@dimX=0\p@
\@BUNKI=1

% 値の引き継ぎ
\tempX@box@scale=\temp@box@scale
\tempX@takasa=\@takasa
\tempX@Swidth=\@Swidth
\tempX@box@thickness@value=\box@thickness@value
\box@thickness{\tempX@box@thickness@value}

\setkeys{putboxes}{#1}

  \@cotA=#2{}% 問題数   A=6
  \@cotB=#3{}% 行の個数 B=3
% 2行以上箱があるとき
  \ifnum\@cotA>\@cotB
    \@cotC=\@cotA
    \@cotD=\@cotB
    \divide\@cotC by \@cotB
    \multiply\@cotD by \@cotC
    \advance\@cotA by -\@cotD
    \newcount\@foo
    \@foo=\@cotC
    \loop
      \@putbox{\@cotB}[scale=\strippt\tempX@box@scale]
      \advance\@foo -1{}
    \ifnum\@foo>0 \repeat \fi
% 1行以下箱があるとき
  \ifnum\@cotA>0
    \@dimX=\tempX@box@scale
    \multiply\@dimX by \@cotA
    \divide\@dimX by \@cotB
    \@putbox{\@cotA}[scale=\strippt\@dimX]
  \fi
%
% 値の引き継ぎ
  \@takasa=\tempX@takasa
  \@Swidth=\tempX@Swidth
  \box@thickness@value=\tempX@box@thickness@value
  \box@thickness{\box@thickness@value}
  \@BUNKI=0
}


\newcommand{\@PUTBOXESstar}[3][%
    scale=1.0
]{%
\@cotA=0
\@cotB=0
\@cotC=0
\@cotD=0
\@dimX=0\p@
\@BUNKI=1

% 値の引き継ぎ
\tempX@box@scale=\temp@box@scale
\tempX@takasa=\@takasa
\tempX@box@thickness@value=\box@thickness@value
\box@thickness{\tempX@box@thickness@value}

\setkeys{putboxes}{#1}
  \@cotA=#2
  \@cotB=#3
% 2行以上箱があるとき
  \ifnum\@cotA>\@cotB%
    \@cotC=\@cotA%
    \@cotD=\@cotB%
    \divide\@cotC by \@cotB{}%
    \multiply\@cotD by \@cotC{}%
    \advance\@cotA by -\@cotD{}%
  %
    \newcount\@foo
    \@foo=\@cotC%
    \loop
      \@putboxstar{\@cotB}[scale=\strippt\tempX@box@scale]%
      \advance\@foo -1{}
    \ifnum\@foo>0
    \repeat
  \fi
%
% 1行以下箱があるとき
  \ifnum\@cotA>0
    \@dimX=\tempX@box@scale% 幅率の変更(2021/05/09)
    \multiply\@dimX by \@cotA%
    \divide\@dimX by \@cotB%
    \@putboxstar{\@cotA}[scale=\strippt\@dimX]% (2021/08/29)
  \fi
%
% 値の引き継ぎ
  \@takasa=\tempX@takasa
  \box@thickness@value=\tempX@box@thickness@value
  \box@thickness{\box@thickness@value}
  \@BUNKI=0
}

  \define@key{putbox}{height}{\@takasa=#1}
  \define@key{putbox}{thickness}{\temp@box@thickness@value=#1 \box@thickness{#1}}
  \define@key{putbox}{shoumon}{
    \setcounter{shoumon@bangou}{#1}
    \addtocounter{shoumon@bangou}{-1}
}
  \define@key{putbox}{scale}{\tempY@box@scale=#1\box@scale}
  \define@key{putbox}{Swidth}{\@Swidth=#1}

\newcommand{\@PUTBOX}[2][%
    scale=1.0
]{%
\@cotX=0
\@cotY=0
\@dimA=0\p@
\@dimB=0\p@
\haba@shoumon=0\p@
% 値の引き継ぎ
\ifnum\@BUNKI=0
  \tempY@takasa=\@takasa
  \tempY@Swidth=\@Swidth
  \tempY@box@thickness@value=\box@thickness@value
  \box@thickness{\tempY@box@thickness@value}
\fi
\tempY@box@scale=\box@scale%

\setkeys{putbox}{#1}
  \bangouA=#2
  \advance\@bangouB by \bangouA
  \@cotX=\bangouA
  \advance\@cotX by -1
% 箱の右下の高さ
  \advance\@choutenB by \@takasa
% 箱の幅
  \@haba=\strippt\tempY@box@scale\@habaA
% 全体の箱
  \draw[line width=\@futosa] (0,-\@choutenA) rectangle (\@haba,-\@choutenB);

\@dimB=\@Swidth
\@dimA=\@haba%

\ifnum\@cotX=0
  \advance \@dimA by -\@dimB{}
\else
  \multiply \@dimB by \bangouA{}
  \advance \@dimA by -\@dimB{}
  \divide \@dimA by \bangouA{}
\fi
\haba@shoumon=0.98\@dimA% ちょっと狭める

\ifnum\@cotX=0
  \draw[line width=\@Hfutosa,densely dotted] (\@Swidth,-\@choutenA)--(\@Swidth,-\@choutenB);% 右側
\else
\foreach ~ in{1,...,\@cotX}{%
  \draw[line width=\@futosa] (\@haba/\bangouA*~,-\@choutenA)--(\@haba/\bangouA*~,-\@choutenB);% 左側
}
\foreach ~ in{0,1,...,\@cotX}{%
  \draw[line width=\@Hfutosa,densely dotted] (\@haba/\bangouA*~+\@Swidth,-\@choutenA)--(\@haba/\bangouA*~+\@Swidth,-\@choutenB);% 右側
}
\fi

\@cotY=\c@shoumon@bangou%
\foreach ~ in{1,...,\bangouA}{%
  \c@shoumon@bangou=\@cotY%
  \advance\c@shoumon@bangou by ~{}
  \coordinate (NO\the\c@shoumon@bangou) at ({\@haba/\bangouA*(~ - 1) +\@Swidth/2},-0.5*\@choutenA-0.5*\@choutenB);
% 解答欄の真ん中の場所
  \coordinate (P\the\c@shoumon@bangou) at ({\@haba/\bangouA*(~ - 1) +\@Swidth +0.5*(\@haba/\bangouA-\@Swidth)},-0.5*\@choutenA-0.5*\@choutenB);
}
% 小問番号の記述
\foreach ~ in{1,...,\bangouA}{%
  \c@shoumon@bangou=\@cotY{}%
  \advance\c@shoumon@bangou by ~{}
  \draw (NO\the\c@shoumon@bangou) node[] {\theshoumon@bangou};
}
% 次の箱の左上の高さ
\advance\@choutenA by \@takasa{}
% 次の行へ番号の引き継ぎ
\c@shoumon@bangou=\@cotY{}%
\advance\c@shoumon@bangou by \bangouA{}
\advance\@bangouB by \bangouA{}

% 値の引き継ぎ
\ifnum\@BUNKI=0
  \@takasa=\tempY@takasa
  \@Swidth=\tempY@Swidth
  \box@thickness@value=\tempY@box@thickness@value
  \box@thickness{\box@thickness@value}
\fi
}

\newcommand{\@PUTBOXstar}[2][%
    scale=1.0
]{%
\@cotX=0
\@cotY=0
\@dimA=0\p@
\haba@shoumon=0\p@

% 値の引き継ぎ
\ifnum\@BUNKI=0
  \tempY@takasa=\@takasa
  \tempY@box@thickness@value=\box@thickness@value
  \box@thickness{\tempY@box@thickness@value}
\fi

\tempY@box@scale=\box@scale%
\setkeys{putbox}{#1}%

  \bangouA=#2
  \advance\@bangouB by \bangouA{}
  \@cotX=\bangouA
  \advance\@cotX by -1{}
% 箱の右下の高さ
  \advance\@choutenB by \@takasa{}
% 箱の幅
  \@haba=\strippt\tempY@box@scale\@habaA%
% 全体の箱 (左上の座標 rectangle 右下の座標)
  \draw[line width=\@futosa] (0,-\@choutenA) rectangle (\@haba,-\@choutenB);

\@dimA=\@haba%
\ifnum\@cotX=0
  \advance \@dimA by -0\p@{}
\else
  \divide \@dimA by \bangouA{}
\fi

\haba@shoumon=0.98\@dimA{}%
% 小問番号の箱の右
\ifnum\@cotX=0{}
\else
\foreach ~ in{1,...,\@cotX}{%
  \draw[line width=\@futosa] (\@haba/\bangouA*~,-\@choutenA)--(\@haba/\bangouA*~,-\@choutenB);% 左側
}
\fi
% 小問番号の場所を決定（点をとる）
\@cotY=\c@shoumon@bangou{}%
\foreach ~ in{1,...,\bangouA}{%
  \c@shoumon@bangou=\@cotY{}%
  \advance\c@shoumon@bangou by ~{}% 小問番号の引継
%
  \coordinate (NO\the\c@shoumon@bangou) at ({\@haba/\bangouA*(~ - 1) +\@Swidth/2},-0.5*\@choutenA-0.5*\@choutenB);%
% 解答欄の真ん中の場所
  \coordinate  (P\the\c@shoumon@bangou) at ({\@haba/\bangouA*(~ - 1) +0.5*\@haba/\bangouA},-0.5*\@choutenA-0.5*\@choutenB);
}
% 小問番号の記述
% 次の箱の左上の高さ
\advance\@choutenA by \@takasa{}
% 次の行へ番号の引継
\c@shoumon@bangou=\@cotY{}%
\addtocounter{shoumon@bangou}{\bangouA}
\advance\@bangouB by \bangouA{}
% 値の引き継ぎ
\ifnum\@BUNKI=0
  \@takasa=\tempY@takasa
  \box@thickness@value=\tempY@box@thickness@value
  \box@thickness{\box@thickness@value}
\fi
}
%---------- all done

\renewcommand\thedaimon@bangou{\textsf{[\@Alph\c@daimon@bangou]}}
\renewcommand\theshoumon@bangou{\textsf{(\@arabic\c@shoumon@bangou)}}

\endinput
