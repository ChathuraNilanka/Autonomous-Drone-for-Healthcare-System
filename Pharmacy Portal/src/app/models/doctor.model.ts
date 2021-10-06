// doctor details saved in petient collection
export interface Patient_doctor{
    name?: string;
    mbbs?: string;
    email?: string;
    docID?: string;
    mobileNumber?: string;
    nic?: string;
    specialty?: string;
    status?: string;
}

// doctor object of doctor collection
export interface Doctor{
    id?: string;
    name?: string;
    mbbs?: string;
    email?: string;
    mobileNumber?: string;
    nic?: string;
    specialty?: string;
    gender?: string;
    uid?: string;
    bio?: string;
    proPic?: string;
}