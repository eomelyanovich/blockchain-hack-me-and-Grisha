fun invoke prev call_fn call_sender block_number call_params =
    case prev of
    (Some prev) =>
        let
            val header = (print "** Block number "; print_int block_number; print " **\n")
            val campaign = Option.valOf(scValue_to_campaign( decodeValue(Option.valOf(get ( prev )))))
            val state    = encodeCampaign campaign
            val call_context = Context call_sender block_number state
            val result = Runtime.call call_fn call_context call_params
        in
            if Option.isNone (get_err result) then
                (print(campaign_toPrettyString ( Option.valOf(scValue_to_campaign( decodeValue(Option.valOf(get ( result ))))) )); Some result)
            else
                (print "Error on block:"; print_int block_number; print "\n"; print(Option.valOf(get_err ( result ))); print "\n"; None)
        end
    | _ => (print "Skipping block as an error occured"; None);

fun main () =
    let
        val storage = [];
        val context = Context 1337 10217 storage;
        val bank_addr = 2200;
        val captain_addr = 2201;
        val captain_name = "Arkadii Samoletov";
        val worker_addr = 2202;
        val worker_name = "Gas Lighter";
        val init_params = [ SCInt 1337, SCString "aviacompany", SCInt 1338, SCString "fuelcompany", SCString "This very simple agreement", SCInt bank_addr ];
        val notify_params = [ SCInt 10, SCNegotiation WaitingCustomer, SCInt 10 ]
        val amount_params = [ SCInt 10, SCInt 10, SCInt 20226 ]
        val task_params = [ SCInt 10, SCNegotiation NegotiationApproved, SCInt captain_addr, SCString captain_name, SCInt worker_addr, SCString worker_name, SCInt 15, SCInt 20, SCInt 30, SCInt 15, SCInt 10, SCInt 10, SCInt 10, SCInt 10, SCTaskStatus GasRequested, SCPaymentType Post ]
        val task_id = [ SCInt 10 ]
        val initial  = Runtime.call 1 context init_params;
        val agreeContract  = invoke (Some initial) 4  1338 10218 []
        val newPriceNotify  = invoke agreeContract        11 1338 10219 notify_params
        val newPriceApprove  = invoke newPriceNotify        9  1337 10220 []
        val newGasTask  = invoke newPriceApprove        17 1337 10221 task_params
        val rejectTask = invoke newGasTask 14 1338 10221 [ SCInt 10 ]
    in
        case rejectTask of
        (Some x) => print("Contracted :)\n")
        | _ => print("Ohh, maybe we can ask supplier first ?\n")
    end;
    
main ();