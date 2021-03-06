'use strict';

/**
* Factory to create error with
*/
var SynthError = () => {

	// Map of errors
	var errors = {
		'1000' : {
			'id' : 1000,
			'errorMessage' : 'Exception occurred',
			'errorDescription' : 'Your request could not be completed. Something unexpected had happened',
			'errorInstructions' : 'Please contact your administrator'
		},
		'1001' : {
			'id' : 1001,
			'errorMessage' : 'Error parsing json object',
			'errorDescription' : 'An error occurred while trying to parse a json object. These could be the possible causes: <ul><li>Character encoding is not supported</li><li>Invalid content mapping</li><li>Content could not be parsed</li><li>Could not write to an object</li></ul>',
			'errorInstruction' : 'Please contact your administrator'
		},
		'1002' : {
			'id' : 1002,
			'errorMessage' : 'Error parsing json object',
			'errorDescription' : 'An error occurred while trying to parse a json object. These could be the possible causes:<ul><li>Invalid content mapping</li><li>Could not write content to json file</li><li>Could not write object to json file</li></ul>',
			'errorInstruction' : 'Please contact your administrator'
		},
		'1003' : {
			'id' : 1003,
			'errorMessage' : 'Could not post event',
			'errorDescription' : 'Could not post the event. These could be the possible causes:<ul><li>The LMS service is down</li><li>Your login credentials are invalid</li></u;>',
			'errorInstruction' : 'Please ensure that the LMS service is up and running and that your log in credentials are valid'
		},
		'1004' : {
			'id' : 1004,
			'errorMessage' : 'File manipulation failed',
			'errorDescription' : 'File manipulation failed. These could be the possible causes:<ul><li>Could not create the directory structure for the code location</li><li>Could not copy the tool code to the code location</li></ul>',
			'errorInstruction' : 'Check that the code location property is correct'
		},
		'1005' : {
			'id' : 1005,
			'errorMessage' : 'Log in failed',
			'errorDescription' : 'Could not log in to LMS for user. These could be the posible causes: <ul><li>The Sakia service is down</li><li>Your log in credentials are invalid</li></ul>',
			'errorInstruction' : 'Check that the Sakia service is running and that your log in credentials are valid.'
		},
		'1006' : {
			'id' : 1006,
			'errorMessage' : 'Retrieval failed',
			'errorDescription' : 'Could not retrieve modules from the LMS service. These could be the possible causes:<ul><li>The LMS service is down</li><li>There was a problem retrieving modules</li></ul>',
			'errorInstruction' : 'Check that the LMS service is running.'
		},
		'1007' : {
			'id' : 1007,
			'errorMessage' : 'Problem reading the sites xml',
			'errorDescription' : 'There was a problem reading the sites xml. These could be the possible causes:<ul><li>Could not compile the xpath expression</li><li>No data was found for the site</li></ul>',
			'errorInstruction' : 'Please contact your administrator'
		},
		'1008' : {
			'id' : 1008,
			'errorMessage' : 'Retrieval failed',
			'errorDescription' : 'The pages and tools could not be retreived from the LMS engine',
			'errorInstruction' : 'Please ensure that the LMS engine is up and running'
		},
		'1009' : {
			'id' : 1009,
			'errorMessage' : 'Configuration failure',
			'errorDescription' : 'The sax parser could not be configured',
			'errorInstruction' : 'Please contact the administrator'
		},
		'1010' : {
			'id' : 1010,
			'errorMessage' : 'Invalid xml document',
			'errorDescription' : 'The xml doucment returned from the LMS service is invalid',
			'errorInstruction' : 'Please contact administrator'
		},
		'1011' : {
			'id' : 1011,
			'errorMessage' : 'Device not recognised',
			'errorDescription' : 'The is no data in the database for this device',
			'errorInstruction' : 'Check that the device is registered and valid on the Unipoole service.'
		},
		'1012' : {
			'id' : 1012,
			'errorMessage' : 'Registration tool not found',
			'errorDescription' : 'The is no registration tool found. The device is registered but the tool is not',
			'errorInstruction' : 'Check that the tool is registered  and valid on the Unipoole service.'
		},
		'1013' : {
			'id' : 1013,
			'errorMessage' : 'Module Registration not found',
			'errorDescription' : 'The module registration could not be found. The device is registered but the module for the device is not',
			'errorInstruction' : 'Check that the module is registered and valid on the Unipoole service.'
		},
		'1014' : {
			'id' : 1014,
			'errorMessage' : 'Invalid location',
			'errorDescription' : 'The location is not valid',
			'errorInstruction' : 'The location must be a directory or zip file containing the tool code in the root.'
		},
		'2002' : {
			'id' : 2002,
			'errorMessage' : 'Invalid login',
			'errorDescription' : 'The log in credentials provided are invalid.',
			'errorInstruction' : 'Please provide valid credentials'
		},
		'2003' : {
			'id' : 2003,
			'errorMessage' : 'Invalid session',
			'errorDescription' : 'The session is invalid. These could be the possible causes:<ul><li>The session does not exist</li><li>The session was not valid</li></ul>',
			'errorInstruction' : ''
		},
		'2004' : {
			'id' : 2004,
			'errorMessage' : 'No tools found',
			'errorDescription' : '',
			'errorInstruction' : ''
		},
		'3000' : {
			'id' : 3000,
			'errorMessage' : 'You need to authenticate to perform this action',
			'errorDescription' : 'The action your requested cannot be performed without authentications',
			'errorInstruction' : 'Please authenticate, and try again'
		},
		'4001' : {
			'id' : 4001,
			'errorMessage' : 'No application available',
			'errorDescription' : 'You do not have an application installed that can open the requested file',
			'errorInstruction' : 'Please install an application supporting the file.'
		},
		'4002' : {
			'id' : 4002,
			'errorMessage' : 'Failed to open file',
			'errorDescription' : 'The requested file could not be opened by an application',
			'errorInstruction' : 'Please make sure a supported application is installed'
		}
	};

	/*
	* Return a function that will create an error that
	* can be used by the SynthErrorHandler.
	*
	* Params:
	* errorCode - an int representing the error code, or an object that represent the error
	* additional (optional) - a string with additional info about the error.
	*/
	return function(errorCode, additional){

		/*
		* Check if the error is an exception
		*/
		if(errorCode instanceof Error){
			let error = angular.copy(errors[1000]);
			error.additional = errorCode.message;
			return error;
		}
		/* Check if the error Code is an object.
		* if it is an object, it is a error like response from
		* a server, we will then create a proper error from it */
		else if (typeof(errorCode) === 'object'){
			return {
				'id' : errorCode.errorCode,
				'errorMessage' : errorCode.message,
				'errorInstruction' : errorCode.instruction,
				'additional' : additional
			};
		}
		else{
			let error = angular.copy(errors[errorCode]);
			// This will only happen if an error happened before the ajax to get
			// the error list was completed
			if(error == null){
				error = {
					'id' : 1000,
					'errorMessage' : 'Exception occurred',
					'errorDescription' : 'Your request could not be completed. Something unexpected had happened',
					'errorInstructions' : 'Please contact your administrator'
				};
			}
			if (additional){
				error.additional = additional;
			}
			return error;
		}

	};
};
SynthError.$inject = [];
export default SynthError;
