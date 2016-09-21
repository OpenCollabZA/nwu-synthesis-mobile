'use strict';

import base from './base';
import tools from './tools';

var SynthMobile = 'SynthMobile';
/* Main application module */
angular.module(SynthMobile, [
	'ngRoute',
	'ngAnimate',
	'ngTouch',
	'ab-base64',
	'ui.bootstrap',
	'frapontillo.bootstrap-switch',
	'ng-iscroll',
	'synthesis.config',
	'synthesis.templates',
	base,
	tools
]);

angular.element(document).ready(function () {
	angular.bootstrap(document, [SynthMobile]);
});
