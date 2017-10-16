var Nuts = require('./nuts');
var platforms = require('./utils/platforms');
var winReleases = require('./utils/win-releases');

require('dotenv').config();

module.exports = {
    Nuts: Nuts,
    platforms: platforms,
    winReleases: winReleases
};
