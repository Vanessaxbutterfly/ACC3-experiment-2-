README for Self-paced reading experiment

Programmed in lab.js, and designed to work with Qualtrics

TF, Oct 2018

FOLDER STRUCTURE AND LINKS

The whole folder can be uploaded to GitHub pages so that it can be loaded as a webpage (independently and in an iframe within Qualtrics). 

Contents:

	DataSource.js: a file for loading in all the filenames or associated data. Alternatively, this could be uploaded elsewhere and called via URL. Linked in a separate script tag in index.html.

	index.html: a home page which will display while the experiment is loading. This also loads in the .js content

	/lib: folder with core files from the lab.js library

	script.js: the actual experiment code, this will be executed once the page loads

	style.css: from lab.js, this allows one to specify custom css

Images could be placed in a sub-folder, or linked from elsewhere on the web. The folder URL is indicated in script.js.


DATASOURCE, PARAMETERS AND CONDITION LABELS

This example uses counterbalanced trial information stored in DataSource.js. This list contains condition labels defined at the top of script.js, which are passed to each template trial by lab.js. They should appear in the results for each screen. The lab.js documentation has some tips/code for parsing the results.


INTEGRATING WITH QUALTRICS

The process for embedding in qualtrics is described here:
https://labjs.readthedocs.io/en/latest/learn/deploy/3a-qualtrics.html

Some useful tips:
1. Remove formatting and set page transitions to "none" (through Look and Feel menu)
2. Make an embedded data variable to save the lab.js data
3. In the javascript for the experiment "question", put code for saving the data and for removing any formatting (see below)
4. In the html for the experiment "question", put iframe linking to GitHub code and any formatting (e.g., removing the next button). See below.



SUGGESTED WORKFLOW

Run a local copy of the code by opening the html in browser (with development tools for debugging). THEN run a hosted copy of the code on the web. THEN run a qualtrics survey with the html embedded.


(CODE FOR QUALTRICS)

See example here: https://essex.eu.qualtrics.com/jfe/form/SV_1XkLIMvySp0WB2l

FOR JS:

	Qualtrics.SurveyEngine.addOnload(function()
	{
		/*Place your JavaScript here to run when the page loads*/
			//console.log('A')
	
			//this code removes the "Powered by Qualtrics" label which might get in the way of our study
			//if it doesn't work, check page transitions are set to NONE
			var plug = document.getElementById("Plug"); //Get the Defined element
			plug.style.cssText += ';display:none !important;'; //Set the defined element's display style to "none"
	});

	Qualtrics.SurveyEngine.addOnReady(function()
	{

	//this code from lab.js will save the data in the embedded data field
	
	// Listen for the study sending data
	window.addEventListener('message', function(event) {

	  // Make sure that the event is from lab.js, then ...
	  if (event.data.type === 'labjs.data') {
		// ... extract the data lab.js is sending.

		// We're going to work with JSON data
		const data = event.data.json

		// ... save data and submit page
		// this must agree with the name of the embedded data
		Qualtrics.SurveyEngine.setEmbeddedData('labjs-data', data)
		document.querySelector('.NextButton').click()
	  }
	})

	});

	Qualtrics.SurveyEngine.addOnUnload(function()
	{
		/*Place your JavaScript here to run when the page is unloaded*/

	});
	
FOR HTML (CHANGE THE SRC TO WHEREVER YOUR FILES ARE):

	<iframe
	  src="https://foulsham.github.io/SPRdemo/index.html"
	  style="width: 100%; height: 100%; min-height: 600px; border: none;"
	></iframe>


	<style>
	  /* Hide button for skipping the page*/
	  .NextButton {
		visibility: hidden;
	  }
	  /* Remove border from last question */
	  .QuestionOuter:last-of-type .QuestionText {
		border: none;
	  }
	</style>
