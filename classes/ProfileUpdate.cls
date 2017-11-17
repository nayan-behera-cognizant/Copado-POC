@RestResource(urlMapping='/ProfileUpdate/*')
global with sharing class ProfileUpdate {

    @HttpPatch
    global static String updateProfile(String userId, String profileId) {
        update new User(
        	Id = userId,
        	ProfileId = profileId
        );
           
        return 'Profile Updated';
    }

}