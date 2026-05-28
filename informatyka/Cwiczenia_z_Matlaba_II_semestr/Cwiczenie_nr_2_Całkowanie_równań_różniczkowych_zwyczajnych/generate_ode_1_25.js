const fs = require('fs');

const latexPre = `% ============================================================
%  Baza 25 Zestawów Zaliczeniowych
%  Całkowanie Równań Różniczkowych Zwyczajnych w MATLAB
% ============================================================
\\documentclass[a4paper,11pt]{article}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage[polish]{babel}
\\usepackage{geometry}
\\geometry{margin=2.2cm}
\\usepackage{booktabs}
\\usepackage{amsmath}
\\usepackage{parskip}
\\usepackage{titlesec}
\\usepackage{fancyhdr}
\\usepackage{lastpage}
\\usepackage{enumitem}
\\usepackage{mdframed}

\\pagestyle{fancy}
\\fancyhf{}
\\rhead{Równania Różniczkowe Zwyczajne -- MATLAB}
\\lhead{Baza Zadań}

\\setlength{\\parindent}{0pt}

\\newmdenv[
  linewidth=0.8pt,
  innerleftmargin=8pt,
  innerrightmargin=8pt,
  innertopmargin=6pt,
  innerbottommargin=6pt
]{ramka}

\\begin{document}
`;

const singleEquations = [
    { eq: "\\frac{dy}{dt} = -2\\sin(y) + 1.5\\cos(5t) + 3", symInd: "t", symDep: "y" },
    { eq: "\\frac{dy}{dt} = 0.5y - t^2", symInd: "t", symDep: "y" },
    { eq: "\\frac{dy}{dx} = -y\\cos(x) + e^{-x}", symInd: "x", symDep: "y" },
    { eq: "\\frac{dy}{dx} = 2x - 3y + 1", symInd: "x", symDep: "y" },
    { eq: "\\frac{dy}{dt} = -0.1y + \\sin(2t)", symInd: "t", symDep: "y" },
    { eq: "\\frac{dy}{dx} = \\frac{x^2 - y}{2}", symInd: "x", symDep: "y" },
    { eq: "\\frac{dy}{dt} = 1 - y^2", symInd: "t", symDep: "y" },
    { eq: "\\frac{dy}{dx} = e^{-x} - 2y", symInd: "x", symDep: "y" },
    { eq: "\\frac{dy}{dt} = y\\sin(t)", symInd: "t", symDep: "y" },
    { eq: "\\frac{dy}{dt} = -1.5y + 3\\cos(2t)e^{-t}", symInd: "t", symDep: "y" }
];

const systemEquations = [
    { eq1: "\\frac{dy_1}{dx} = 0.1y_1 - \\cos(y_2) + x", eq2: "\\frac{dy_2}{dx} = -2y_2 + \\sin(y_1)", symInd: "x", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dt} = 0.5y_1 - 0.2y_2", eq2: "\\frac{dy_2}{dt} = 0.1y_1 - 0.3y_2", symInd: "t", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dx} = -y_1 + y_2^2", eq2: "\\frac{dy_2}{dx} = y_1 - y_2", symInd: "x", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dt} = \\sin(y_2) - y_1", eq2: "\\frac{dy_2}{dt} = \\cos(y_1) - y_2", symInd: "t", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dx} = 2y_1 - 3y_2 + x", eq2: "\\frac{dy_2}{dx} = y_1 + y_2 - x^2", symInd: "x", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dt} = y_2 - t", eq2: "\\frac{dy_2}{dt} = -y_1 + y_2", symInd: "t", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dx} = -2y_1 + y_2", eq2: "\\frac{dy_2}{dx} = 0.5y_1 - y_2 + \\sin(x)", symInd: "x", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dt} = y_1(1 - y_2)", eq2: "\\frac{dy_2}{dt} = -y_2(1 - y_1)", symInd: "t", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dx} = 1.5y_1 - \\cos(y_2)", eq2: "\\frac{dy_2}{dx} = -0.5y_2 + \\sin(x)", symInd: "x", symDep1: "y_1", symDep2: "y_2" },
    { eq1: "\\frac{dy_1}{dt} = -y_1 + e^{-t}y_2", eq2: "\\frac{dy_2}{dt} = -y_2 + e^{t}y_1", symInd: "t", symDep1: "y_1", symDep2: "y_2" }
];

const optionStyles = [
    { a: "1", b: "2", type: "jako liczbę" },
    { a: "10", b: "20", type: "jako liczbę" },
    { a: "pojedyncze", b: "uklad", type: "jako tekst" },
    { a: "p", b: "u", type: "jako tekst" },
    { a: "zad1", b: "zad2", type: "jako tekst" },
    { a: "przedzial (0, 1>", b: "przedzial <2, 3)", type: "jako liczbe z przedzialu" } // Specific for the first assignment style
];

const plotStyles = [
    { grid: "Włącz podstawową siatkę (grid on)", lineSingle: "linią ciągłą w kolorze czerwonym", lineSys1: "linią przerywaną niebieską", lineSys2: "linią kropkowaną czerwoną", marker: "kółkami ('o')", pos: "w lewym górnym rogu ('northwest')" },
    { grid: "Wykres bez siatki (grid off)", lineSingle: "linią przerywaną szarą", lineSys1: "grubą linią czarną", lineSys2: "linią ciągłą zieloną", marker: "gwiazdkami ('*')", pos: "w najlepszym dopasowanym miejscu ('best')" },
    { grid: "Siatka jest obowiązkowa", lineSingle: "grubą linią zieloną", lineSys1: "linią ciągłą magenta", lineSys2: "linią przerywaną czarną", marker: "kwadratami ('s')", pos: "w prawym dolnym rogu ('southeast')" },
    { grid: "Zastosuj gęstą siatkę (grid minor)", lineSingle: "cienką linią czarną", lineSys1: "linią kropkowaną niebieską", lineSys2: "grubą linią czerwoną", marker: "krzyżykami ('+')", pos: "poza obszarem osi ('outside')" },
    { grid: "Dodaj standardową siatkę", lineSingle: "linią ciągłą niebieską", lineSys1: "linią przerywaną zieloną", lineSys2: "linią ciągłą czarną", marker: "rombami ('d')", pos: "w lewym dolnym rogu ('southwest')" }
];

let content = latexPre;

for (let i = 1; i <= 25; i++) {
    content += `\\begin{center}\n  {\\large\\bfseries Zestaw nr ${i} \\quad -- \\quad Całkowanie równań różniczkowych zwyczajnych}\n\\end{center}\n\\hrulefill\n\\vspace{0.4cm}\n\n`;
    
    // Select equations
    const singleEq = singleEquations[i % singleEquations.length];
    const sysEq = systemEquations[(i + 3) % systemEquations.length];
    const opt = optionStyles[i % optionStyles.length];
    const pOpt = plotStyles[i % plotStyles.length];
    
    const wybor_skladnia = (i % 2 === 0 || opt.type.includes("przedzial")) ? "if/else" : "switch/case";
    const solver1 = (i % 2 === 0) ? "ode23" : "ode45";
    const solver2 = (i % 2 === 0) ? "ode45" : "ode23";
    
    // Parameter handling styles
    const paramInputStyle = (i % 3 === 0) ? "hardcoded" : ((i % 3 === 1) ? "input" : "mixed");
    
    content += `\\subsection*{Polecenia}\n\nNapisz skrypt w programie MATLAB rozwiązujący podane zagadnienia początkowe. Skrypt musi pobierać od użytkownika wybór zadania (wybór z menu).\n\n\\begin{enumerate}[leftmargin=*, label=\\textbf{\\arabic*.}, itemsep=2pt]\n\n`;
    
    content += `  \\item \\textbf{Inicjalizacja.}\n    Nazwa pliku: \\texttt{nazwisko\\_imie\\_cw\\_nr}. W komentarzu wewnątrz pliku: zestaw nr: ${i}, wyczyszczenie środowiska roboczego, ekranu oraz zamknięcie wszystkich otwartych okien graficznych.\n\n`;
    
    if (opt.type === "jako liczbe z przedzialu") {
        content += `  \\item \\textbf{Wybór zadania -- \\texttt{${wybor_skladnia}}.}\n    Wyświetl czytelne menu. Użytkownik wybiera zadanie podając liczbę. Opcja dla jednego równania: liczba należąca do przedziału $(0; 1\\rangle$. Opcja dla układu: liczba należąca do przedziału $\\langle 2; 3)$. Obsłuż wariant błędny komunikatem: \\textit{Wprowadzono niepoprawną liczbę}.\n\n`;
    } else {
        content += `  \\item \\textbf{Wybór zadania -- \\texttt{${wybor_skladnia}}.}\n    Wyświetl czytelne menu. Użytkownik wybiera opcję ${opt.type}: wpisując \\textbf{'${opt.a}'} rozwiązuje pojedyncze równanie, wpisując \\textbf{'${opt.b}'} rozwiązuje układ równań. Obsłuż wariant błędny komunikatem: \\textit{Niepoprawny wybór}.\n\n`;
    }

    // Task A: Single Equation
    content += `  \\item \\textbf{Opcja 1: Pojedyncze równanie.}\n`;
    content += `    Rozwiąż równanie zdefiniowane we wbudowanej funkcji (tzw. \\textit{lokalnej} na dole pliku):\n`;
    content += `    \\[ ${singleEq.eq} \\]\n`;
    
    let t_start1 = (i % 5);
    let t_end1 = t_start1 + 2 + (i % 3);
    let t_step1 = (0.01 + (i % 5) * 0.02).toFixed(2).replace('.', '{,}');
    let y0_1 = (i * 0.5 - 2).toFixed(1).replace('.', '{,}');
    
    if (paramInputStyle === "input" || paramInputStyle === "mixed") {
        content += `    Poproś użytkownika instrukcją \\texttt{input} o~podanie \\textbf{kroku całkowania} (np. skok) oraz \\textbf{warunku początkowego} $${singleEq.symDep}_0$. Przyjmij przedział całkowania $${singleEq.symInd} \\in \\langle ${t_start1};\\,${t_end1} \\rangle$.\n`;
    } else {
        content += `    Zdefiniuj zmienne na sztywno w kodzie: krok całkowania równy $${t_step1}$, warunek początkowy $${singleEq.symDep}_0 = ${y0_1}$. Przedział całkowania $${singleEq.symInd} \\in \\langle ${t_start1};\\,${t_end1} \\rangle$.\n`;
    }
    content += `    Do obliczeń wykorzystaj solver \\texttt{${solver1}}. Następnie wygeneruj wykres zależności $${singleEq.symDep}(${singleEq.symInd})$. Narysuj wykres ${pOpt.lineSingle}, a punkty obliczone przez solver oznacz ${pOpt.marker}. Dodaj podpisy osi oraz tytuł. ${pOpt.grid}.\n\n`;

    // Task B: System of Equations
    const t_start2 = (i % 3);
    const t_end2 = t_start2 + 3 + (i % 2);
    const t_step2 = (0.05 + (i % 2) * 0.05).toFixed(2).replace('.', '{,}');
    const y1_0 = (i % 4).toString();
    const y2_0 = (5 - (i % 3)).toString();

    content += `  \\item \\textbf{Opcja 2: Układ równań.}\n`;
    content += `    Rozwiąż układ równań zdefiniowany w jednej funkcji:\\\\[-0.5em]\n`;
    content += `    \\[\n    \\begin{cases}\n      ${sysEq.eq1} \\\\\n      ${sysEq.eq2}\n    \\end{cases}\n    \\]\n`;
    
    if (paramInputStyle === "input" || (paramInputStyle === "mixed" && i % 2 === 0)) {
        content += `    Parametry wprowadza użytkownik z klawiatury (skok całkowania oraz warunki początkowe $ {${sysEq.symDep1}}_{0} $ i $ {${sysEq.symDep2}}_{0} $). Przedział całkowania $${sysEq.symInd} \\in \\langle ${t_start2};\\,${t_end2} \\rangle$.\n`;
    } else {
        content += `    Parametry podane są jako liczby przypisane do zmiennych wymuszonych w locie (bez instrukcji input): skok całkowania $${t_step2}$, warunek startowy $ {${sysEq.symDep1}}_{0} = ${y1_0} $, $ {${sysEq.symDep2}}_{0} = ${y2_0} $. Przedział całkowania to $${sysEq.symInd} \\in \\langle ${t_start2};\\,${t_end2} \\rangle$.\n`;
    }
    content += `    Rozwiąż układ równań wykorzystując solver \\texttt{${solver2}}. Wykresy wynikowych zmiennych przedstaw na wspólnym układzie współrzędnych. Przebieg pierwszej zmiennej narysuj ${pOpt.lineSys1}, a drugiej -- ${pOpt.lineSys2}. Punkty numeryczne obliczone przez solver zaznacz ${pOpt.marker}. Dodaj legendę jednoznacznie opisującą każdą z krzywych i umieść ją ${pOpt.pos}. Koniecznie podpisz osie oraz dodaj tytuł wykresu. ${pOpt.grid}.\n\n`;

    content += `\\end{enumerate}\n\n`;
    
    content += `\\vspace{0.3cm}\n\\begin{ramka}\n\\textbf{Wymagane konstrukcje:}\n`;
    content += `\\texttt{${wybor_skladnia}}, \\texttt{disp}, \\texttt{input}, \\texttt{${solver1}}, \\texttt{${solver2}}, \\texttt{plot}, użycie funkcji lokalnych (local functions).\n`;
    content += `\\end{ramka}\n\n`;
    
    if (i < 25) {
        content += `\\clearpage\n`;
    }
}

content += `\\end{document}\n`;

fs.writeFileSync('c:/Users/szymo/Desktop/Informatyka/Ćwiczenia z Matlaba II semestr/zestawy_ode_25.tex', content, 'utf8');
console.log('Zestawy ODE wygenerowane pomyślnie!');
