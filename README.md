# etnetera-task

# Localizations
They are done via legacy string files since they play nicely with all the online tools and swiftgen.

To add new, just add it to corresponding strings file and run script `swiftgen config run` on the main folder.
Precondition: installed swiftgen

# Google service info plist
It is necessary to generate firebase plist to be able to use firestore. Due to security reasons original file is not included. Normally it would be either restricted by bundleID, copied on server build and never being commited to the repo. 