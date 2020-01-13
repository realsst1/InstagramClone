const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onFollowUser = functions.firestore
  .document('followers/{userId}/usersFollowers/{followerId}')
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const followerId = context.params.followerId;
    const followedUserPostsRef = admin
      .firestore()
      .collection('posts')
      .doc(userId)
      .collection('userPosts');
    const userFeedRef = admin
      .firestore()
      .collection('feeds')
      .doc(followerId)
      .collection('userFeed');
    console.log("in follow uppper")
    const followedUserPostsSnapshot = await followedUserPostsRef.get();
    console.log("snap size:"+followedUserPostsSnapshot.size+"\nDocs:"+followedUserPostsSnapshot.docs)
    followedUserPostsSnapshot.forEach(doc => {
      console.log("in loooooo")
      if (doc.exists) {
        userFeedRef.doc(doc.id).set(doc.data());
      }
      console.log("in loop")
    });
  });

// exports.onFollowUser=functions.firestore
// .document('followers/{userId}/usersFollowers/{followerId}').onCreate((event) => {
//     return admin.firestore()
//         .collection('ruleSets')
//         .doc(1234)
//         .get()
//         .then(doc => {
//             console.log('Got rule: ' + doc.data().name);
//         });
// });

exports.onUnfollowUser = functions.firestore
  .document('followers/{userId}/usersFollowers/{followerId}')
  .onDelete(async (snapshot, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;
    const userFeedRef = admin
      .firestore()
      .collection('feeds')
      .doc(followerId)
      .collection('userFeed')
      .where('authorId', '==', userId);
    const userPostsSnapshot = await userFeedRef.get();
    console.log(userPostsSnapshot.docs)
    userPostsSnapshot.forEach(doc => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onUploadPost = functions.firestore
  .document('posts/{userId}/userPosts/{postId}')
  .onCreate(async (snapshot, context) => {
    console.log(snapshot.data());
    const userId = context.params.userId;
    const postId = context.params.postId;
    const userFollowersRef = admin
      .firestore()
      .collection('followers')
      .doc(userId)
      .collection('usersFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach(doc => {
      admin
        .firestore()
        .collection('feeds')
        .doc(doc.id)
        .collection('userFeed')
        .doc(postId)
        .set(snapshot.data());
    });
  });

exports.onUpdatePost = functions.firestore
  .document('posts/{userId}/userPosts/{postId}')
  .onUpdate(async (snapshot, context) => {
    const userId = context.params.userId;
    const postId = context.params.postId;
    const newPostData = snapshot.after.data();
    console.log(newPostData);
    const userFollowersRef = admin
      .firestore()
      .collection('followers')
      .doc(userId)
      .collection('usersFollowers');
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach(async userDoc => {
      const postRef = admin
        .firestore()
        .collection('feeds')
        .doc(userDoc.id)
        .collection('userFeed');
      const postDoc = await postRef.doc(postId).get();
      if (postDoc.exists) {
        postDoc.ref.update(newPostData);
      }
    });
  });


exports.createUser = functions.firestore
    .document('users/{userId}')
    .onCreate((snap, context) => {
      // Get an object representing the document
      // e.g. {'name': 'Marie', 'age': 66}
      const newValue = snap.data();
      console.log("new user trigger")

      // access a particular field as you would any JS property
      const name = newValue.name;

      // perform desired operations ...
    });

