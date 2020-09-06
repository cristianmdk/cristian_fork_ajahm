const JWTSECRET = process.env.JWTSECRET;
const MONGODB_URI = 'mongodb+srv://dbUSER:dbUSER@cluster-midterm.zx57i.mongodb.net/midtermDB?retryWrites=true&w=majority';

module.exports = {
    jwtSecret: JWTSECRET,
    mongodburi: MONGODB_URI
};
