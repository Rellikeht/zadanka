// SimpleService.ice
module Demo {
    interface SimpleService {
        // This operation returns the identity of the object
        string getIdentity();
        
        // This operation returns the servant type (dedicated or shared)
        string getServantType();
        
        // This operation simulates some processing
        string process(string input);
    };
};
