global class scheduledDevicesDeleteonAccount implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchUserDevicesDeleteonAccount b = new BatchUserDevicesDeleteonAccount(); 
      database.executebatch(b);
   }
}