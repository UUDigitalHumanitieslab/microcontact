# Please update the next few lines if you are starting a new translation.
# This is the ITALIAN text for the Microcontact website.
# It was mostly written by FRANCESCO CICONTE.
# It was translated from ENGLISH.

# This is a comment. Comments are not visible to the visitors of the website.
# Comments should not be translated. You only need to translate the pieces of
# text between quotes. Also, please skip everything that looks like computer
# code.

# Countries
AR: 'Argentina'
BR: 'Brasile'
CA: 'Canada'
US: 'USA'
IT: 'Italia'

# Italian languages
Abruzzese: 'Abruzzese/Teatino'
Florentine: 'Fiorentino'
Neapolitan: 'Napoletano (Campano)'
Palermitan: 'Palermitano (Siciliano)'
Piedmontese: 'Piemontese'
Salentino: 'Salentino'
Sienese: 'Senese (Toscano)'
Venetan: 'Veneto'

# General buttons etcetera
closeButtonLabel: 'Close'
fieldRequired: '(obbligatorio)'
placeFieldPlaceholder: 'Città/paese'

# Map background
dhLabLogoHoverText: 'Digital Humanities Lab at Utrecht University'

# Navigation menu
navParticipateLink: 'Partecipate'
navContributionsLink: 'Mostra le registrazioni'

# Welcome panel
welcomeTitle: 'Benvenuti nel sito Microcontact'
welcomeLead: 'Partecipa anche tu alla documentazione e alla valorizzazione
	delle varietà italiane parlate nelle Americhe!'
welcomeShowMoreButton: 'Continua a leggere...'
welcomeCollapsedText: '''
	<p class="collapse welcome-more">Vai da un membro anziano della tua famiglia che parla il dialetto.<br>Registra con il tuo telefonino il parlante. Poi carica il file audio sul sito. Il racconto registrato può essere lungo fino a un massimo di 10 minuti. Il parlante può raccontare un evento della sua infanzia, la sua giovinezza, un viaggio, la guerra, un ricordo passato, ecc.</p>
	<p class="collapse welcome-more">Quando la registrazione è pronta, cerca sulla mappa la città/paese in cui vive ora il parlante. Clicca sulla città/paese per cominciare il caricamento della registrazione.</p>
'''
welcomeThankYou: 'Grazie per la collaborazione!'
welcomeSignature: 'Il gruppo di ricerca'
welcomeParticipateButton: 'Partecipa'

# Contributions, place listing
justAnExampleMsg: 'Il sito è ancora in costruzione. Questo è solo un esempio.
	I contributi non sono ancora presenti.'
numberOfContributions: '{{pins.length}} contribution(s)'
	# {{pins.length}} is a number

# Participate, choose country
chooseCountryTitle: 'Seleziona il tuo Paese'

# Participate, search place
searchPlaceTitle: 'Trova la località'
searchPlaceLead: 'Inserisci il nome della località in <em>{{countryLong}}</em>.'
	# {{countryLong}} is the name of a country
searchPlaceFieldLabel: 'Località:'
searchPlaceButtonText: 'Cerca'
searchPlaceNothingFound: 'Non ci sono risultati per &ldquo;{{query}}&rdquo;.
	Controlla se hai scritto corettamente la località e prova di nuovo.'
	# &ldquo;{{query}}&rdquo; is a quoted search query
searchPlaceErrorTryLater: 'C’è stato un errore durante la ricerca.
	Prova di nuovo più tardi.'

# Participate, pick place from results
pickPlaceTitle: 'Scegli la località tra i risultati'
pickPlaceLead: 'Sotto trovi i risultati della ricerca di
	<em>&ldquo;{{query}}&rdquo;</em> in {{countryLong}}. <strong>Clicca sul
	cerchietto della località per cominciare il caricamento.</strong>'
	# <em>&ldquo;{{query}}&rdquo;</em> is a quoted search query
	# {{countryLong}} is the name of a country

# General validators
minFileSizeMsg: 'Il file deve essere minimo di {0}.'
maxFileSizeMsg: 'Il file deve essere massimo di {0}.'

# Upload form, top/bottom status messages
invalidFieldsWarning: '{0} campi sono stati riempiti incorrettamente.
	Ricontrolla e prova di nuovo.'
	# {0} is a number
uploadInProgressMsg: 'Caricamento in corso. Si prega di attendere...'
serverRejectMsg: 'Alcuni campi non sono validi. Ricontrolla. {0}'
	# {0} is any amount of text in full sentences.
serverErrorMsg: 'L’invio non è riuscito per problemi tecnici.
	Riprova più tardi. Se il problema continua,
	contatta un membro del gruppo di ricerca.'
uploadSuccessMsg: 'Grazie!'

# Upload form, file field
recordingLabel: 'La tua registrazione'
recordingGeneralError: 'Carica un file audio di 5 minuti (minimo) fino a
	10 minuti (massimo).'
recordingMaxSizeError: 'Il tuo file è troppo grande.
	Alternativamente, puoi usare un formato compresso, per esempio FLAC,
	oppure puoi ridurre il file in qualità CD (se stai usando risoluzioni
	più avanzate). Puoi anche provare a tagliare i segmenti silenziosi
	della tua registrazione (pause, interruzioni, ecc...) per ottenere un
	file più piccolo di {0}.'
	# {0} is a file size, expressed like: 100 MB

# Upload form, sociolinguistic variables section
sociolinguisticLegend: 'Informazioni sulla registrazione e sul parlante'
dialectFieldLabel: 'Dialetto del paese di provenienza'
otherLanguagesFieldLabel: 'Quali altre lingue conosce il parlante?'
countryFieldLabel: 'Nazione'
placeFieldLabel: 'Città'
ageFieldLabel: 'Età'
sexFieldLabel: 'Sesso'
sexFieldMale: 'maschile'
sexFieldFemale: 'femminile'
sexFieldOther: 'altro'
educationFieldLabel: 'Livello di istruzione'
educationFieldElementary: 'elementare'
educationFieldMiddle: 'scuola media'
educationFieldHigh: 'scuola superiore'
educationFieldUniversity: 'università'
bornInItalyLabel: 'Sono nato in Italia.'
bornHereLabel: 'Sono nato in {{countryName}}.'
bornInYearLabel: 'Sono emigrato dall’Italia nell’anno'
bornInVillageLabel: 'Sono nato a'
bornInProvinceLabel: 'in provincia di'
provincePlaceholder: 'Provincia'

# Upload form, uploader contact section
uploaderLegend: 'Informazioni sulla persona che effettua il caricamento del file.'
uploaderPrivacyNote: 'I tuoi dati personali non saranno mai resi pubblici.'
nameFieldLabel: 'Nome e Cognome'  # should be a full name
namePlaceholder: 'Christina Alvarez'
atleastOneContactDetail: '(dare almeno un tipo di contatto)'
emailFieldLabel: 'Email'
emailPlaceholder: 'calvarez@example.com'
telephoneFieldLabel: 'Telefono'
telephonePlaceholder: '+1 123456789'  # please localize

# Upload form, bottom section
uploadButton: 'Invia'
informedConsent: '''
	Selezionando questa casella e inviando la registrazione audio, sia la
	persona che carica il file sia la persona che è stata registrata confermano
	di aver letto e capito il <a href="#participant-information" target=_blank>
		Modulo informativo per il partecipante</a>,
	e confermano inoltre di essere d’accordo a partecipare allo studio.
'''

# Information form (this is one big block of HTML)
informationFormText: '''
	<h1>MODULO INFORMATIVO DEL PARTECIPANTE</h1>
	<p class=lead>Grazie per aver accettato di partecipare a questo studio. Questo modulo descrive lo scopo del nostro studio, il tipo di partecipazione richiesta e i tuoi diritti di partecipante.</p>
	<p><strong>Informazioni e scopi:</strong> lo scopo di questo studio è capire cosa succede quando due lingue entrano in contatto. Per fare questo, raccoglieremo e studieremo dati linguistici da immigrati italiani di prima generazione che sono emigrati nel Nord e Sud America tra il 1940 e il 1960, e dati linguistici dai loro discendenti (eredità linguistica). Puoi partecipare a questa ricerca se sei un italiano immigrato in America (del Nord e del Sud), o se appartieni a una famiglia di immigrati.</p>
	<p><strong>La tua partecipazione:</strong> la tua partecipazione a questo studio si svolgerà nel seguente modo.</p>
	<section>
		<p><u>Prima fase della ricerca:</u></p>
		<ul>
			<li>Se sei nato in Italia o in America e parli uno dei seguenti dialetti:
				<ul class=list-inline>
					<li>veneto,</li>
					<li>piemontese,</li>
					<li>napoletano/campano,</li>
					<li>abruzzese,</li>
					<li>palermitano/siciliano,</li>
					<li>salentino,</li>
					<li>fiorentino o</li>
					<li>senese</li>
				</ul>
				chiedi a qualcuno che sa usare internet di registrarti e caricare la tua registrazione sull’<a href="https://microcontact.hum.uu.nl/#contributions" target=_blank>atlante interattivo</a>. Se riesci a farlo da solo, puoi certamente farlo tu stesso, senza chiedere aiuto ad altri.</li>
			<li>Per favore, fai una registrazione di massimo 10 minuti (o anche più breve) in cui racconti una storia di quando sei arrivato in America o un episodio che ti è successo da bambino o da giovane.</li>
		</ul>
		<p>Dopo aver registrato, il file audio può essere caricato sull’atlante interattivo, dove potrà essere ascoltato da chiunque sia interessato. Il tuo nome e cognome non saranno mai pubblici.</p>
	</section>
	<section>
		<p><u>Seconda fase della ricerca:</u></p>
		<p>Se la tua lingua è selezionata per la seconda fase, sarai contattato da un ricercatore, che verrà nella tua città per farti un’intervista. L’intervista non sarà più lunga di 1 ora e riguarderà soltanto la tua lingua. </p>
		<p>La partecipazione a questa ricerca è volontaria e gratis. Non c’è nessuna contravvenzione se la partecipazione è interrotta. Puoi decidere di non partecipare a tutte le fasi e puoi ritirare il tuo contributo in qualunque momento.</p>
		<p><strong>Benefici e rischi:</strong> il beneficio della tua partecipazione è contribuire informazioni per l’analisi linguistica e per capire come funzionano le lingue quando entrano in contatto con altre lingue. Offrirai inoltre una preziosa documentazione della tua lingua, che sarà molto utile per chiunque lavori sulla cultura e la storia degli emigrati italiani.<br>
		Non ci sono rischi associati alla partecipazione a questo studio. Non ti saranno mai chiesti soldi o contributi materiali di qualsiasi tipo durante le fasi della ricerca. Stai solo aiutando la ricerca scientifica.</p>
		<p><strong>Riservatezza:</strong> il tuo nome e cognome non saranno registrati e non saranno mai resi pubblici. Le tue informazioni identificative non saranno associate a nessuna relazione scritta della ricerca. Tutte le tue informazioni e risposte nell’intervista saranno riservate. Il ricercatore non condividerà queste informazioni con nessun altro, ma solo con i membri del gruppo di ricerca.</p>
		<p>Se hai domande, dubbi o reclami, puoi contattare la Prof. Roberta D’Alessandro (vedi sotto).</p>
	</section>
	<section>
		<h2>CONTATTI</h2>
		<address><table class=contact-table>
			<tr><td><strong>Coordinatrice del progetto:</strong></td><td>Prof. Roberta D’Alessandro</td></tr>
			<tr><td>Indirizzo:</td><td>
				Department of TLC / Taalwetenschap UiL OTS<br>
				Faculty of Humanities<br>
				Trans 10, 3512 JK, Utrecht<br>
				The Netherlands
			</td></tr>
			<tr><td>Telefono:</td><td>+31 30 253 3596</td></tr>
			<tr><td>Email:</td><td>r.dalessandro@uu.nl</td></tr>
	<tr><td></td><td></td></tr>
			<tr><td><strong>Email del gruppo di ricerca:</strong></td><td>microcontact@uu.nl</td></tr>
		</table></address>
	</section>
'''
