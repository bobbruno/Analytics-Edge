MODEL_DIVIDER = '[1] "==============================================================================="\n'
COEFFICIENTS = 'Coefficients:\n'
END_COEFFICIENTS = '---\n'
QUESTIONS = {'Q96024':'Are you good at math?',
    'Q98059':'Do/did you have any siblings?',
    'Q98078':'Do you have a "go-to" creative outlet?',
    'Q98197':'Do you pray or meditate on a regular basis?',
    'Q98578':'Do you exercise 3 or more times per week?',
    'Q98869':'Does life have a purpose?',
    'Q99480':'Did your parents spank you as a form of discipline/punishment?',
    'Q99581':'Are you left-handed?',
    'Q99716':'Do you live alone?',
    'Q99982':'Do you keep check-lists of tasks you need to accomplish?',
    'Q100010':'Do you watch some amount of TV most days?',
    'Q100562':'Do you think your life will be better five years from now than it is today?',
    'Q100680':'Have you cried in the past 60 days?',
    'Q100689':'Do you feel like you are currently overweight?',
    'Q101162':'Are you generally more of an optimist or a pessimist?',
    'Q101163':'Which parent "wore the pants" in your household?',
    'Q101596':'As a kid, did you ever build (or help build) a tree-house?',
    'Q102089':'Do you rent or own your primary residence?',
    'Q102289':'Does your life feel adventurous?',
    'Q102674':'Do you have any credit card debt that is more than one month old?',
    'Q102687':'Do you eat breakfast every day?',
    'Q102906':'Are you currently carrying a grudge against anyone in your personal life?',
    'Q103293':'Do you have more than one pet?',
    'Q104996':'Do you brush your teeth two or more times every day?',
    'Q105655':'Were you awakened by an alarm clock this morning?',
    'Q105840':'Do you ever treat yourself to "retail therapy"?',
    'Q106042':'Are you taking any prescription medications?',
    'Q106272':'Do you own any power tools? (power saws, drills, etc.)',
    'Q106388':'Do you work 50+ hours per week?',
    'Q106389':'Are you a good/effective liar?',
    'Q106993':'Do you like your given first name?',
    'Q106997':'Do you generally like people, or do most of them tend to get on your nerves pretty easily?',
    'Q107491':'Do you punctuate text messages?',
    'Q107869':'Do you feel like you`re "normal"?',
    'Q108342':'Do you spend more time with friends online or in-person?',
    'Q108343':'Do you feel like you have too much personal financial debt?',
    'Q108617':'Do you live in a single-parent household?',
    'Q108754':'Do both of your parents have college degrees?',
    'Q108855':'Do you enjoy getting together with your extended family?',
    'Q108856':'Lots of people are around! Are you more likely to be right in the middle of things, or looking for your own quieter space?',
    'Q108950':'Are you generally a cautious person, or are you comfortable taking risks?',
    'Q109244':'Are you a feminist?',
    'Q109367':'Have you ever been poor (however you personally defined it at the time)?',
    'Q110740':'Mac or PC?',
    'Q111220':'Is your alarm clock intentionally set to be a few minutes fast?',
    'Q111580':'As a teenager, do/did you have parents who were generally more supportive or demanding?',
    'Q111848':'Did you ever get a straight-A report card in high school or college?',
    'Q112270':'Are you better looking than your best friend?',
    'Q112478':'Do you have any phobias?',
    'Q112512':'Are you naturally skeptical?',
    'Q113181':'Do you meditate or pray on a regular basis?',
    'Q113583':'While driving: music or talk/news radio?',
    'Q113584':'During your average day, do you spend more time interacting with people (face-to-face) or technology?',
    'Q113992':'Do you gamble?',
    'Q114152':'Do you support a particular charitable cause with a lot of your time and/or money?',
    'Q114386':'Are you more likely to over-share or under-share?',
    'Q114517':'Do you turn a TV on in the morning while getting ready for your day?',
    'Q114748':'Do you drink the unfiltered tap water in your home?',
    'Q114961':'Can money buy happiness?',
    'Q115195':'Do you live within 20 miles of a major metropolitan area?',
    'Q115390':'Has your personality changed much from what you were like as a child?',
    'Q115602':'Were you an obedient child?',
    'Q115610':'Does the "power of positive thinking" actually work?',
    'Q115611':'Do you personally own a gun?',
    'Q115777':'Do you find it easier to start and maintain a new good habit, or to permanently kick a bad habit?',
    'Q115899':'Would you say most of the hardship in your life has been the result of circumstances beyond your own control, or has it been mostly the result of your own decisions and actions?',
    'Q116197':'Are you a morning person or a night person?',
    'Q116441':'Do you have a car payment?',
    'Q116448':'If you had to stop telling *any* lies for 6 months (even the smallest "little-white-lie" would immediately make you violently ill), would it change your life in any noticeable way?',
    'Q116601':'Have you ever traveled out of the U.S.?',
    'Q116797':'Do you take a daily multi-vitamin?',
    'Q116881':'Would you rather be happy or right?',
    'Q116953':'Do you like rules?',
    'Q117186':'Do you have a quick temper?',
    'Q117193':'Do you work (or attend school) on a pretty standard "9-to-5ish" daytime schedule, or do you have to work unusual hours?',
    'Q118117':'Have you lived in the same state your whole life?',
    'Q118232':'Are you more of an idealist or a pragmatist?',
    'Q118233':'Have you ever had your life genuinely threatened by intentional violence (or the threat of it)?',
    'Q118237':'Do you feel like you are "in over-your-head" in any aspect of your life right now?',
    'Q118892':'Do you wear glasses or contact lenses?',
    'Q119334':'Did you accomplish anything exciting or inspiring in 2013? (comments from the 2012 poll are linked for inspiration)',
    'Q119650':'Which do you really enjoy more: giving or receiving?',
    'Q119851':'Are you in the middle of reading a good book right now?',
    'Q120012':'Does the weather have a large effect on your mood?',
    'Q120014':'Are you more successful than most of your high-school friends?',
    'Q120194':'Your generally preferred approach to starting a new task: read up on everything you can before trying it out, or dive in with almost no knowledge and learn as you go?',
    'Q120379':'Do you have (or plan to pursue) a Masters or Doctoral degree?',
    'Q120472':'Science or Art?',
    'Q120650':'Were your parents married when you were born?',
    'Q120978':'As a kid, did you watch Sesame Street on a regular basis?',
    'Q121011':'Changing or losing a job, getting married or divorced, the death of a close relative, moving, a major health issue, bankruptcy...all are life events that can create high stress for people. Have you experienced any of these in 2013?',
    'Q121699':'2013: did you drink alcohol?',
    'Q121700':'2013: did you start a new romantic relationship?',
    'Q122120':'Your significant other takes an extra long look at a very attractive person (of your gender) walking past both of you. Are you upset?',
    'Q122769':'Do you collect anything (as a hobby)?',
    'Q122770':'Do you have more than $20 cash in your wallet or purse right now?',
    'Q122771':'Do/did you get most of your K-12 education in public school, or private school?',
    'Q123464':'Do you currently have a job that pays minimum wage?',
    'Q123621':'Are you currently employed in a full-time job?',
    'Q124122':'Did your parents fight in front of you?',
    'Q124742':'Do you have to personally interact with anyone that you really dislike on a daily basis?',
    'HasKids':'Do you have kids ?',
    'EducationLevel':'What is your educational level ?',
    'YOB': 'What is your year of birth ?',
    'minIncome': 'What is the bottom of your income range ?',
    'maxIncome': 'What is the top of your income range ?',
    'Party': 'What is your political party preference ?',
    'LivesTogether': 'Do you live with a significant other ?',
    'Gender':'What is your gender ?'
    }

def isfloat(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

class Modelo:
    def __init__(self, formula, AUC, coefficients, AIC):
        self.formula = ''.join(formula).replace("'",'')
        self.AUC = AUC
        self.coefficients = coefficients.copy()
        self.AIC = AIC
    def __str__(self):
        texto = "Formula: Happy ~ {}\nAUC: {:f}\n".format(self.formula, self.AUC)
        texto += "Coefficients:\n\t\tEstimate\t\tStdErr\t\tz Val\t\tPr(>|z|)\t\tImportance\n"
        for coeff, dados in self.coefficients.iteritems():
            texto += "{0}\t{1}\t\t{2}\t\t{3}\t\t{4}\t\t{5}\n".format(
                    coeff,
                    dados['estim'],
                    dados['stderr'],
                    dados['z'],
                    dados['p'],
                    dados['importance'])
        return(texto)
    def __lt__(self, other):
        return self.AUC < other.AUC

    def __le__(self, other):
        return self.AUC <= other.AUC

    def __gt__(self, other):
        return self.AUC > other.AUC

    def __gt__(self, other):
        return self.AUC >= other.AUC

    def __eq__(self, other):
        return self.AUC == other.AUC
        
    def __ne__(self, other):
        return self.AUC != other.AUC

def printtopn(list, n):
    for m in list[-n:]:
        texto = "Happy ~ " + m.formula + '\n'
        for question in m.formula.split("*"):
            texto += QUESTIONS[question] + '\n'
        print texto, "AUC: ", m.AUC        

def CarregaModelos(arq, direc = None):
    if (not(direc is None)):
        arqui = direc + '/' +arq
    arquivo=open(arqui, 'rb')
    numModels = long(arquivo.readline().split()[2])
    Modelos = []
    get_formula = False
    get_coeffs = False
    for linha in arquivo:
        if linha == MODEL_DIVIDER:
            get_formula = True
            continue
        if get_formula:
            formula = linha.split()[4:-3]
            AUC = float(linha.split()[-1].replace('"',''))
            get_formula = False
        if linha == COEFFICIENTS:
            get_coeffs = True
            coefficients = {}
            continue
        if get_coeffs:
            if linha == END_COEFFICIENTS or linha == '\n':
                get_coeffs = False
                continue
            else:
                if linha[0:10] == '          ':
                    continue
                else:
                    elements = linha.split()
                    try:
                        while (not isfloat(elements[1])):
                            elements[:2] = [' '.join(elements[:2])]
                    except IndexError:
                        print(linha)
                        elements = [elements[0],0, 0, 0, 0, "none"]
                        
                    if len(elements) < 6:
                        elements.append("none")
                    coefficients[elements[0]] = {"estim": elements[1],
                                           "stderr": elements[2],
                                           "z": elements[3],
                                           "p": elements[4],
                                           "importance": elements[5],
                                           }
        if linha[:4] == 'AIC:':
            AIC = float(linha.split()[1])
            Modelos.append(Modelo(formula, AUC, coefficients, AIC))
    Modelos.sort()
    return Modelos

def topvars(lista, AUCMin=0.6):
    vardict = {}
    for m in lista:
        if m.AUC < AUCMin:
            continue
        for question in m.formula.split("*"):
            if vardict.has_key(question):
                vardict[question] += 1
            else:
                vardict[question] = 1
    return sorted(vardict.iteritems(), key=lambda x:x[1], reverse=True)

def printtopvars(varlist, n):
    if n > len(varlist):
        n = len(varlist)
    for var in varlist[:n]:
        print var[0], " "*(12-len(var[0])), var[1], "modelos:\t", QUESTIONS[var[0]]
