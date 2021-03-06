# Please update the next few lines if you are starting a new translation.
# This is the ENGLISH text for the Microcontact website.
# It was mostly written by JULIAN GONGGRIJP.
# It was translated from ENGLISH.

# This is a comment. Comments are not visible to the visitors of the website.
# Comments should not be translated. You only need to translate the pieces of
# text between quotes. Also, please skip everything that looks like computer
# code.

currentLanguage: 'en'

# General buttons etcetera
closeButtonLabel: 'Close'
fieldRequired: '(required)'
placeFieldPlaceholder: 'City/village'

# Map background
dhLabLogoHoverText: 'Digital Humanities Lab at Utrecht University'

# Navigation menu
navParticipateLink: 'Participate'
navContributionsLink: 'Show recordings'

# Welcome panel
welcomeTitle: 'Welcome to Microcontact'
welcomeLead: 'Participate to the documentation and preservation of the Italian dialects spoken in the Americas!<br>
	(How to: <a href="https://www.youtube.com/watch?v=VXLl2HPWdiM" target=_blank>video</a>).'
welcomeShowMoreButton: 'Read more...'
welcomeCollapsedText: '''
	<p class="collapse welcome-more">Go to an older member of your family who speaks the dialect.<br>Record the speaker with your phone. Then upload the audio file on our website. The recording can be max. 10-minute long, or less. The speaker can talk about an event of his/her childhood or youth, describe the war, tell a short story or a past memory, etc.</p>
<p class="collapse welcome-more">When the recording is ready, please find on the map the town/village where the speaker currently lives. Click on the town/village to start uploading the recording.</p>
'''
welcomeThankYou: 'Thank you for your cooperation!'
welcomeSignature: 'The research team'
welcomeLink: 'The website of our project'
welcomeEnter: 'Enter'

# Contributions, legend
dialectLegendTitle: 'Legend of dialect colors'
dialectLegendButton: 'Legend'

# Contributions, place listing
numberOfContributions: '{{recordings.length}} contribution(s)'
	# {{recordings.length}} is a number

# Contributions, details
contributionShowDetails: 'Show details'
contributionDetailsRecId: 'Recording id'
contributionDetailsAge: 'Age'
contributionDetailsSex: 'Sex'
contributionDetailsEducation: 'Level of education'
contributionDetailsOrigin: 'Place of origin'
contributionDetailsMigrated: 'Migrated in'
contributionDetailsLanguages: 'Other languages'
contributionDetailsDatasource: 'Data source'

# contributions, search
contributionsSearchPlaceHolder: 'Search by place'

# Participate, choose country
chooseCountryTitle: 'Choose your country'

# Participate, search place
searchPlaceTitle: 'Find your location'
searchPlaceLead: 'Please enter the name of your city or village in
	<em>{{countryLong}}</em>.'
	# {{countryLong}} is the name of a country
searchPlaceFieldLabel: 'Place:'
searchPlaceButtonText: 'Search'
searchPlaceNothingFound: 'No results were found for &ldquo;{{query}}&rdquo;.
	Please check your spelling and try again.'
	# &ldquo;{{query}}&rdquo; is a quoted search query
searchPlaceErrorTryLater: 'An error occurred during the search.
	Please try again later.'

# Participate, pick place from results
pickPlaceTitle: 'Pick your place from the results'
pickPlaceLead: 'Below are the search results for
	<em>&ldquo;{{query}}&rdquo;</em> in {{countryLong}}. <strong>Please click
	on the pin over your location to start uploading.</strong>'
	# <em>&ldquo;{{query}}&rdquo;</em> is a quoted search query
	# {{countryLong}} is the name of a country

# General validators
minFileSizeMsg: 'The file must be at least {0} in size.'
maxFileSizeMsg: 'The file must be at most {0} in size.'

# Upload form, top/bottom status messages
invalidFieldsWarning: '{0} fields were filled out incorrectly.
	Please review the form and try again.'
	# {0} is a number
uploadInProgressMsg: 'Uploading, please wait...'
serverRejectMsg: 'Some of the fields were invalid, please review. {0}'
	# {0} is any amount of text in full sentences.
serverErrorMsg: 'Submission failed for technical reasons.
	Please try again later. If the problem persists,
	please contact the researcher.'
uploadSuccessMsg: 'Thank you!'

# Upload form, file field
recordingLabel: 'Your recording'
recordingGeneralError: 'Please upload an audio file of 5 to 10 minutes.'
recordingMaxSizeError: 'Your file is too large.
	Alternatively, you can use a compressed format, for example FLAC,
	reduce the file to CD quality (if you are using more advanced
	resolutions), or try clipping silent segments out of your recording,
	to get the file size under {0}.'
	# {0} is a file size, expressed like: 100 MB

# Upload form, sociolinguistic variables section
sociolinguisticLegend: 'About the recording and the speaker'
dialectFieldLabel: 'Dialect of the hometown in Italy'
otherLanguagesFieldLabel: 'What other languages does the speaker know?'
otherLanguagesPlaceholder: 'none'
countryFieldLabel: 'Country'
placeFieldLabel: 'City'
ageFieldLabel: 'Age'
sexFieldLabel: 'Sex'
sexFieldMale: 'male'
sexFieldFemale: 'female'
sexFieldOther: 'other'
educationFieldLabel: 'Level of education'
educationFieldElementary: 'elementary'
educationFieldMiddle: 'middle'
educationFieldHigh: 'high'
educationFieldUniversity: 'university'
movedNeverLabel: 'I have always lived in {{name}}.'
movedWithinItalyLabel: 'I moved to {{name}}.'
movedFromLabel: 'I moved from'
placeOfOriginPlaceholder: 'Place of origin'
movedInYearLabel: 'in the year'
bornInItalyLabel: 'I was born in Italy.'
bornHereLabel: 'I was born in {{countryName}}.'
bornInYearLabel: 'I emigrated from Italy in'
bornInVillageLabel: 'I was born in'
bornInProvinceLabel: 'in the province of'
provincePlaceholder: 'Province'

# Upload form, uploader details section
uploaderLegend: 'About the uploader of the recording'
uploaderPrivacyNote: 'Your personal details will never be published.'
nameFieldLabel: 'Name'  # should be a full name
namePlaceholder: 'Christina Alvarez'
atleastOneContactDetail: '(please provide at least one contact detail)'
emailFieldLabel: 'Email'
emailPlaceholder: 'calvarez@example.com'
telephoneFieldLabel: 'Phone'
telephonePlaceholder: '+1 123456789'  # please localize
uploaderRelationIsSpeaker: 'Uploader is the person recorded'
uploaderRelationIsNotSpeaker: 'Uploader is not the person recorded'
uploaderSpecifyRelationLabel: 'Relation to the speaker'
uploaderSpecifyRelationPlaceholder: 'Daughter, Son, Grandson...'

# Upload form, bottom section
uploadButton: 'Submit'
informedConsent: '''
	By ticking this box and submitting the audio file, both the uploader and
	the person who has been recorded confirm that they have read and understood
	the <a href="#participant-information" target=_blank>
		Participant Information Form</a>,
	and they also confirm that they agree to participate in the study.
'''

# Information form (this is one big block of HTML)
informationFormText: '''
	<h1>PARTICIPANT INFORMATION FORM</h1>
	<p class=lead>Thank you for agreeing to participate in this study. This form details the purpose of this study, a description of the involvement required and your rights as a participant.</p>
	<p><strong>Information and Purpose:</strong> The purpose of this study is to understand what happens when two languages get in contact. We aim to do this by collecting and studying language data of first-generation Italian immigrants who moved to North or South America between the 1940s and the 1960s, and those of their descendants (heritage languages). You can participate in this research if you are an Italian immigrant to America (North or South), or if you belong to a family of immigrants.</p>
	<p><strong>Your Participation:</strong> Your participation in this study will consist in the following.</p>
	<section>
		<p><u>First stage of the research:</u></p>
		<ul>
			<li>If you were born in Italy or in America and speak one of the following:
				<ul class=list-inline>
					<li>Venetan,</li>
					<li>Piedmontese,</li>
					<li>Neapolitan/Campano,</li>
					<li>Abruzzese,</li>
					<li>Palermitan/Sicilian,</li>
					<li>Salentino,</li>
					<li>Florentine or</li>
					<li>Senese</li>
				</ul>
				ask somebody who knows how to use internet to record you and upload your recording on <a href="https://microcontact.hum.uu.nl/#contributions" target=_blank>the interactive atlas</a>. If you know how to do this yourself, you can certainly do it.</li>
			<li>Please record max 10 minutes (or even shorter), in which you tell the story of when you arrived in America, or about something that happened when you were young.</li>
		</ul>
		<p>After the recording has taken place, the audio file can be uploaded on an interactive atlas, where it will be hearable by anyone interested. Your name will never be made public.</p>
	</section>
	<section>
		<p><u>Second stage of the research:</u></p>
		<p>If your language is selected for a second stage, you will be contacted by a researcher, who will come to your town to interview you. The interview will last no more than 1 hour, and will only concern your language. </p>
		<p>Participation in this research is voluntary and free. There is no penalty for discontinuing participation, you can decide not to participate in all stages, and you can withdraw at any time.</p>
		<p><strong>Benefits and Risks:</strong> The benefit of your participation is to contribute information for linguistic analysis, for understanding how languages work when they are in contact with other languages. You will also offer very important documentation of your language, which will be of use for anybody working on the culture and history of Italian emigrants.<br>
		There are no risks associated with participating in the study. You will never be asked any money or any material contribution, in any form, at any stage of the research. You will only be helping science.</p>
		<p><strong>Confidentiality:</strong> Your name will not be recorded and will never appear publicly. Your name and identifying information will not be associated with any part of the written report of the research. All of your information and interview responses will be kept confidential.  The researcher will not share your individual responses with anyone other than the research team.</p>
		<p><strong>Data storage and security:</strong> To avoid hacking and data leaking, we follow the data security standards at Utrecht University. The data and backups will be securely stored in the protected repository vault of Utrecht University, and will be monitored by the local system administrators (ICT & Media Backoffice) and by the security guards of Utrecht University. The data will be stored for 10 years.</p>
		<p><strong>Approval of the study:</strong>The Ethical Assessment Committee Linguistics (ETCL) at the Utrecht Institute of Linguistics OTS has approved this study. In case you wish to file a complaint about this study, please see contacts below</p>
		<p>If you have any questions, concerns or complaints, please contact Prof. Roberta D’Alessandro (see below).</p>
	</section>
	<section>
		<h2>CONTACTS</h2>
		<address><table class=contact-table>
			<tr><td><strong>Project Coordinator:</strong></td><td>Prof. Roberta D’Alessandro</td></tr>
			<tr><td>Address:</td><td>
				Department of TLC / Taalwetenschap UiL OTS<br>
				Faculty of Humanities<br>
				Trans 10, 3512 JK, Utrecht<br>
				The Netherlands
			</td></tr>
			<tr><td>Telephone:</td><td>+31 30 253 3596</td></tr>
			<tr><td>Email:</td><td>r.dalessandro@uu.nl</td></tr>
	<tr><td></td><td></td></tr>
			<tr><td><strong>Research Team Email:</strong></td><td>microcontact@uu.nl</td></tr>
			<tr>
			 <td><strong>Ethical Assessment Committee:</strong></td>
			 <td>M.K.A. de Klerk (Maartje)</td>
			</tr>
			<tr><td>Address:</td><td>
				Ethische ToetsingsCommissie Linguïstiek (ETCL)<br>
				Janskerkhof 13, 3512 BL, Utrecht
			</td></tr>
			<tr><td>Telephone:</td><td>+31 30 253 8472</td></tr>
			<tr><td>Email:</td><td>m.k.a.deklerk@uu.nl</td></tr>
		</table></address>
	</section>
'''
