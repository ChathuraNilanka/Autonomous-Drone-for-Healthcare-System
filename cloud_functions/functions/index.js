const functions = require('firebase-functions');
const admin = require('firebase-admin');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });QAQlEf1rq8fI8MGhPr7BFPjPI6j1
admin.initializeApp();
const db = admin.firestore();
//
// exports.requestViewAccess = functions.firestore
//     .document('doctor/{doctorId}/patients/{cID}')
//     .onCreate((snapshot, context) => {
//
//         const patient = snapshot.data();
//         const pid = patient.pid;
//
//         const docRef = db.collection('notification').doc(pid);
//         console.log("Identify the patient : " + pid);
//         var payload = {
//             notification: {
//                 title: "Attention",
//                 body: "A doctor request to view your profile."
//             },
//             data: {
//                 screen: "request_view",
//             }
//         };
//         var options = {
//             priority: "high",
//             timeToLive: 60 * 60 *24
//           };
//
//         const getDoc = docRef.get().then((doc) => {
//             console.log("hello");
//             if (doc.exists) {
//                 const token = doc.data().token;
//                 console.log("Fetch the token");
//                 // eslint-disable-next-line promise/no-nesting
//                 return admin.messaging().sendToDevice(token, payload, options)
//                     .then((response) => {
//                         console.log("Successfully sent message:", response);
//
//                     })
//                     .catch((error) => {
//                         console.log("Error sending message:", error);
//                     });
//             } else {
//                 console.log("No such document!");
//             }
//         }).catch((error) => {
//             console.log("Error getting document:", error);
//         });
//
//         // return admin.messaging().sendToTopic(topicId, payload, options);
//     });

// send notification when doctor request to view patients profile
    exports.requestViewAccess = functions.firestore
    .document('doctor/{doctorId}/patients/{cID}')
    .onCreate(async (snapshot, context) => {

        const patient = snapshot.data();
        const pid = patient.pid;

        const notificationDoc = await db.collection('notification').doc(pid).get();
        console.log("Identify the patient : " + pid);
        if(notificationDoc.exists){
            const token = notificationDoc.data().token;
            const notificationSetupDoc = await db.collection('setup').doc('notifications').collection('request').doc('create').get();
            let notification = notificationSetupDoc.data();
            const doctor = await db.collection('doctor').doc(context.params.doctorId).get();
            let name = doctor.data().name;
            let payload = {
                notification: {
                    title: notification.title,
                    body: notification.body.replace('xxx',name),
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                },
                data: {
                    screen: notification.screen,
                    id:context.params.cID,
                    doctorId:context.params.doctorId,
                    title: notification.title,
                    body: notification.body.replace('xxx',name),
                }
            };
            let options = {
                priority: "high",
                timeToLive: 60 * 60 *24
            };
            let result = await admin.messaging().sendToDevice(token, payload, options);
            console.log(result);
        }
    });

    // send notification when doctor change the patient data
    exports.updateViewAccess = functions.firestore
    .document('doctor/{doctorId}/patients/{cID}')
    .onUpdate(async (snapshot, context) => {

        const patient = snapshot.after.data();
        const pid = patient.pid;

        const notificationDoc = await db.collection('notification').doc(pid).get();
        console.log("Identify the patient : " + pid);
        if(notificationDoc.exists) {
            const token = notificationDoc.data().token;
            const notificationSetupDoc = await db.collection('setup').doc('notifications').collection('request').doc('update').get();
            let notification = notificationSetupDoc.data();
            const doctor = await db.collection('doctor').doc(context.params.doctorId).get();
            let name = doctor.data().name;
            let payload = {
                notification: {
                    title: notification.title,
                    body: notification.body.replace('xxx', name).replace('yyy', patient.status),
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                },
                data: {
                    screen: notification.screen,
                    id: context.params.cID,
                    title: notification.title,
                    body: notification.body.replace('xxx', name).replace('yyy', patient.status),
                }
            };
            let options = {
                priority: "high",
                timeToLive: 60 * 60 * 24
            };
            let result = await admin.messaging().sendToDevice(token, payload, options);
            console.log(result);
        }
    });
// send notification when doctor delete the patient from his list
    exports.deleteViewAccess = functions.firestore
    .document('doctor/{doctorId}/patients/{cID}')
    .onDelete(async (snapshot, context) => {
        const pid = snapshot.get("pid");
        // const pid = patient.pid;

        const notificationDoc = await db.collection('notification').doc(pid).get();
        console.log("Identify the patient : " + pid);
        if(notificationDoc.exists) {
            const token = notificationDoc.data().token;
            const notificationSetupDoc = await db.collection('setup').doc('notifications').collection('request').doc('delete').get();
            let notification = notificationSetupDoc.data();
            const doctor = await db.collection('doctor').doc(context.params.doctorId).get();
            let name = doctor.data().name;
            let payload = {
                notification: {
                    title: notification.title,
                    body: notification.body.replace('xxx',name),
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                },
                data: {
                    screen: notification.screen,
                    id:context.params.cID,
                    title: notification.title,
                    body: notification.body.replace('xxx',name),
                }
            };
            let options = {
                priority: "high",
                timeToLive: 60 * 60 * 24
            };
            let result = await admin.messaging().sendToDevice(token, payload, options);
            console.log(result);
        }
    });

exports.updateOrderStatus = functions.firestore
    .document('order/{orderId}')
    .onUpdate(async (snapshot, context) => {

        const order = snapshot.after.data();
        const orderBefore = snapshot.before.data();
        if(order.orderStatus === orderBefore.orderStatus ||order.orderStatus === "paid" || order.orderStatus === "waiting"){
            return;
        }
        const pid = order.patientId;

        const notificationDoc = await db.collection('notification').doc(pid).get();
        console.log("Identify the patient : " + pid);
        if(notificationDoc.exists) {
            const token = notificationDoc.data().token;
            const notificationSetupDoc = await db.collection('setup').doc('notifications').collection('order').doc('update').get();
            let notification = notificationSetupDoc.data();
            let payload = {
                notification: {
                    title: notification.title,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                },
                data: {
                    screen: notification.screen,
                    id: context.params.orderId,
                    title: notification.title,
                    body: notification.body,
                }
            };
            let options = {
                priority: "high",
                timeToLive: 60 * 60 * 24
            };
            let result = await admin.messaging().sendToDevice(token, payload, options);
            console.log(result);
        }
    });

exports.updateDroneStatus = functions.firestore
    .document('Drones/{droneId}')
    .onUpdate(async (snapshot, context) => {

        const drone = snapshot.after.data();
        if(!drone.isArrived && drone.isReleased)
            return;

        const orderID = drone.currentOrder;

        const order =await db.collection('order').doc(orderID).get();
        const pid = order.data().patientId;

        const notificationDoc = await db.collection('notification').doc(pid).get();
        console.log("Identify the patient : " + pid);
        if(notificationDoc.exists) {
            const token = notificationDoc.data().token;
            const notificationSetupDoc = await db.collection('setup').doc('notifications').collection('drone').doc('release').get();
            let notification = notificationSetupDoc.data();
            let payload = {
                notification: {
                    title: notification.title,
                    click_action: 'FLUTTER_NOTIFICATION_CLICK'
                },
                data: {
                    screen: notification.screen,
                    id: orderID,
                    droneId:context.params.droneId,
                    title: notification.title,
                    body: notification.body,
                }
            };
            let options = {
                priority: "high",
                timeToLive: 60 * 60 * 24
            };
            let result = await admin.messaging().sendToDevice(token, payload, options);
            console.log(result);
        }
    });
