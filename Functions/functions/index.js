const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.sendNotifications = functions.firestore.document('Task_Management/{uid}/Tasks/{id}').onCreate(async (snapshot, context) => {
	//

	if (snapshot.empty) {
		console.log('No Devices');
		return;
	}
     console.log('Device Found');
	newData = snapshot.data();
	const uid = context.params.uid;
	console.log('Current User is' , uid);


	const deviceIdTokens = await admin
		.firestore()
		.collection('User_Management')
		.doc(uid).get();
		console.log('Document is' , deviceIdTokens.data());

	var tokens = deviceIdTokens.data().Device_Token
	
	var payload = {
		notification: {
			title: 'TASK MANAGEMENT APP',
			body: 'New Task Added',
			sound: 'default',
		},
		data: {
			message: newData.task,
		}
	};
	console.log(newData.task);

	try {
		const response = await admin.messaging().sendToDevice(tokens , payload);
		console.log('Notification sent successfully');
	} catch (err) {
		console.log(err);
	}
});
