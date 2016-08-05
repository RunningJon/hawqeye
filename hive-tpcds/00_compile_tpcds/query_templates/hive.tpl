 -- $Id: pivotal.tpl,v 2.1 2016/08/05 09:43:02 jgr Exp $
define __LIMITA = "";
define __LIMITB = "";
define __LIMITC = "limit %d";
define _BEGIN = "-- start query " + [_QUERY] + " in stream " + [_STREAM] + " using template " + [_TEMPLATE] + " and seed " + [_SEED];
define _END = "-- end query " + [_QUERY] + " in stream " + [_STREAM] + " using template " + [_TEMPLATE];
