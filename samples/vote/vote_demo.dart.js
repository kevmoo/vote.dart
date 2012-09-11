function Isolate() {}
init();

var $$ = {};
var $ = Isolate.$isolateProperties;
$$.ExceptionImplementation = {"":
 ["_msg"],
 "super": "Object",
 toString$0: function(){var t1=this._msg;return t1==null?'Exception':'Exception: '+$.S(t1);},
 is$Exception: true
};

$$.FutureImpl = {"":
 ["_isComplete", "_lib0_value?", "_exception", "_stackTrace", "_exceptionHandled", "_successListeners", "_exceptionHandlers", "_completionListeners"],
 "super": "Object",
 get$value: function(){if(this.get$isComplete()!==true)throw $.$$throw($.FutureNotCompleteException$());var t1=this._exception;if(!(t1==null))throw $.$$throw(t1);return this._lib0_value;},
 get$exception: function(){if(this.get$isComplete()!==true)throw $.$$throw($.FutureNotCompleteException$());return this._exception;},
 get$stackTrace: function(){if(this.get$isComplete()!==true)throw $.$$throw($.FutureNotCompleteException$());return this._stackTrace;},
 get$isComplete: function(){return this._isComplete;},
 get$hasValue: function(){return this.get$isComplete()===true&&this._exception==null;},
 then$1: function(onSuccess){if(this.get$hasValue()===true)onSuccess.call$1(this.get$value());else if(this.get$isComplete()!==true)this._successListeners.push(onSuccess);else if(this._exceptionHandled!==true)throw $.$$throw(this._exception);},
 handleException$1: function(onException){if(this._exceptionHandled===true)return;if(this._isComplete===true){var t1=this._exception;if(!(t1==null))this._exceptionHandled=onException.call$1(t1);}else this._exceptionHandlers.push(onException);},
 _complete$0: function(){this._isComplete=true;try{if(!(this._exception==null))for(var t1=$.iterator(this._exceptionHandlers);t1.hasNext$0()===true;){var handler=t1.next$0();if($.eqB(handler.call$1(this._exception),true)){this._exceptionHandled=true;break;}}if(this.get$hasValue()===true)for(t1=$.iterator(this._successListeners);t1.hasNext$0()===true;){var listener=t1.next$0();listener.call$1(this.get$value());}else if(this._exceptionHandled!==true&&$.gtB($.get$length(this._successListeners),0))throw $.$$throw(this._exception);}finally{for(t1=$.iterator(this._completionListeners);t1.hasNext$0()===true;){var listener0=t1.next$0();try{listener0.call$1(this);}catch(exception){$.unwrapException(exception);}}}},
 _setValue$1: function(value){if(this._isComplete===true)throw $.$$throw($.FutureAlreadyCompleteException$());this._lib0_value=value;this._complete$0();},
 _setException$2: function(exception,stackTrace){if(exception==null)throw $.$$throw($.IllegalArgumentException$(null));if(this._isComplete===true)throw $.$$throw($.FutureAlreadyCompleteException$());this._exception=exception;this._stackTrace=stackTrace;this._complete$0();}
};

$$.CompleterImpl = {"":
 ["_futureImpl"],
 "super": "Object",
 get$future: function(){return this._futureImpl;},
 complete$1: function(value){this._futureImpl._setValue$1(value);},
 completeException$2: function(exception,stackTrace){this._futureImpl._setException$2(exception,stackTrace);},
 completeException$1: function(exception) {
  return this.completeException$2(exception,null)
},
 completeException$1: function(exception) {
  return this.completeException$2(exception,null)
}
};

$$.HashMapImplementation = {"":
 ["_keys?", "_values", "_loadLimit", "_numberOfEntries", "_numberOfDeleted"],
 "super": "Object",
 _probeForAdding$1: function(key){var t1=$.hashCode(key);if(t1!==(t1|0))return this._probeForAdding$1$bailout(1,key,t1,0,0,0);var t3=$.get$length(this._keys);if(t3!==(t3|0))return this._probeForAdding$1$bailout(2,key,t1,t3,0,0);var hash=(t1&t3-1)>>>0;for(var numberOfProbes=1,insertionIndex=-1;true;){t1=this._keys;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this._probeForAdding$1$bailout(3,key,hash,numberOfProbes,insertionIndex,t1);if(hash<0||hash>=t1.length)throw $.ioore(hash);var existingKey=t1[hash];if(existingKey==null){if(insertionIndex<0)return hash;return insertionIndex;}else if($.eqB(existingKey,key))return hash;else if(insertionIndex<0&&$.CTC13===existingKey)insertionIndex=hash;var numberOfProbes0=numberOfProbes+1;hash=$.HashMapImplementation__nextProbe(hash,numberOfProbes,$.get$length(this._keys));if(hash!==(hash|0))return this._probeForAdding$1$bailout(4,numberOfProbes0,key,insertionIndex,hash,0);numberOfProbes=numberOfProbes0;}},
 _probeForAdding$1$bailout: function(state,env0,env1,env2,env3,env4){switch(state){case 1:var key=env0;t1=env1;break;case 2:key=env0;t1=env1;t3=env2;break;case 3:key=env0;hash=env1;numberOfProbes=env2;insertionIndex=env3;t1=env4;break;case 4:numberOfProbes0=env0;key=env1;insertionIndex=env2;hash=env3;break;}switch(state){case 0:var t1=$.hashCode(key);case 1:state=0;var t3=$.get$length(this._keys);case 2:state=0;var hash=$.and(t1,$.sub(t3,1));var numberOfProbes=1;var insertionIndex=-1;default:L0:while(true)switch(state){case 0:if(!true)break L0;t1=this._keys;case 3:state=0;var existingKey=$.index(t1,hash);if(existingKey==null){if($.ltB(insertionIndex,0))return hash;return insertionIndex;}else if($.eqB(existingKey,key))return hash;else if($.ltB(insertionIndex,0)&&$.CTC13===existingKey)insertionIndex=hash;var numberOfProbes0=numberOfProbes+1;hash=$.HashMapImplementation__nextProbe(hash,numberOfProbes,$.get$length(this._keys));case 4:state=0;numberOfProbes=numberOfProbes0;}}},
 _probeForLookup$1: function(key){var hash=$.and($.hashCode(key),$.sub($.get$length(this._keys),1));if(hash!==(hash|0))return this._probeForLookup$1$bailout(1,key,hash);for(var numberOfProbes=1;true;){var existingKey=$.index(this._keys,hash);if(existingKey==null)return -1;if($.eqB(existingKey,key))return hash;var numberOfProbes0=numberOfProbes+1;hash=$.HashMapImplementation__nextProbe(hash,numberOfProbes,$.get$length(this._keys));numberOfProbes=numberOfProbes0;}},
 _probeForLookup$1$bailout: function(state,key,hash){for(var numberOfProbes=1;true;){var existingKey=$.index(this._keys,hash);if(existingKey==null)return -1;if($.eqB(existingKey,key))return hash;var numberOfProbes0=numberOfProbes+1;hash=$.HashMapImplementation__nextProbe(hash,numberOfProbes,$.get$length(this._keys));numberOfProbes=numberOfProbes0;}},
 _ensureCapacity$0: function(){var newNumberOfEntries=$.add(this._numberOfEntries,1);if($.geB(newNumberOfEntries,this._loadLimit)){this._grow$1($.mul($.get$length(this._keys),2));return;}var numberOfFree=$.sub($.sub($.get$length(this._keys),newNumberOfEntries),this._numberOfDeleted);if($.gtB(this._numberOfDeleted,numberOfFree))this._grow$1($.get$length(this._keys));},
 _grow$1: function(newCapacity){var capacity=$.get$length(this._keys);if(typeof capacity!=='number')return this._grow$1$bailout(1,newCapacity,capacity,0,0);this._loadLimit=$.tdiv($.mul(newCapacity,3),4);var oldKeys=this._keys;if(typeof oldKeys!=='string'&&(typeof oldKeys!=='object'||oldKeys===null||oldKeys.constructor!==Array&&!oldKeys.is$JavaScriptIndexingBehavior()))return this._grow$1$bailout(2,newCapacity,oldKeys,capacity,0);var oldValues=this._values;if(typeof oldValues!=='string'&&(typeof oldValues!=='object'||oldValues===null||oldValues.constructor!==Array&&!oldValues.is$JavaScriptIndexingBehavior()))return this._grow$1$bailout(3,newCapacity,oldKeys,oldValues,capacity);this._keys=$.ListImplementation_List(newCapacity);this._values=$.ListImplementation_List(newCapacity,$.getRuntimeTypeInfo(this).V);for(var i=0;i<capacity;++i){if(i<0||i>=oldKeys.length)throw $.ioore(i);var key=oldKeys[i];if(key==null||key===$.CTC13)continue;if(i<0||i>=oldValues.length)throw $.ioore(i);var value=oldValues[i];var newIndex=this._probeForAdding$1(key);$.indexSet(this._keys,newIndex,key);$.indexSet(this._values,newIndex,value);}this._numberOfDeleted=0;},
 _grow$1$bailout: function(state,env0,env1,env2,env3){switch(state){case 1:var newCapacity=env0;capacity=env1;break;case 2:newCapacity=env0;oldKeys=env1;capacity=env2;break;case 3:newCapacity=env0;oldKeys=env1;oldValues=env2;capacity=env3;break;}switch(state){case 0:var capacity=$.get$length(this._keys);case 1:state=0;this._loadLimit=$.tdiv($.mul(newCapacity,3),4);var oldKeys=this._keys;case 2:state=0;var oldValues=this._values;case 3:state=0;this._keys=$.ListImplementation_List(newCapacity);this._values=$.ListImplementation_List(newCapacity,$.getRuntimeTypeInfo(this).V);for(var i=0;$.ltB(i,capacity);++i){var key=$.index(oldKeys,i);if(key==null||key===$.CTC13)continue;var value=$.index(oldValues,i);var newIndex=this._probeForAdding$1(key);$.indexSet(this._keys,newIndex,key);$.indexSet(this._values,newIndex,value);}this._numberOfDeleted=0;}},
 clear$0: function(){this._numberOfEntries=0;this._numberOfDeleted=0;var length$=$.get$length(this._keys);if(typeof length$!=='number')return this.clear$0$bailout(1,length$);for(var i=0;i<length$;++i){$.indexSet(this._keys,i,null);$.indexSet(this._values,i,null);}},
 clear$0$bailout: function(state,length$){for(var i=0;$.ltB(i,length$);++i){$.indexSet(this._keys,i,null);$.indexSet(this._values,i,null);}},
 operator$indexSet$2: function(key,value){this._ensureCapacity$0();var index=this._probeForAdding$1(key);var t1=this._keys;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.operator$indexSet$2$bailout(1,key,value,index,t1);if(index!==(index|0))throw $.iae(index);if(index<0||index>=t1.length)throw $.ioore(index);if(!(t1[index]==null)){if(index<0||index>=t1.length)throw $.ioore(index);var t2=t1[index]===$.CTC13;t1=t2;}else t1=true;if(t1){t1=this._numberOfEntries;if(typeof t1!=='number')return this.operator$indexSet$2$bailout(3,key,value,t1,index);this._numberOfEntries=t1+1;}t1=this._keys;if(typeof t1!=='object'||t1===null||(t1.constructor!==Array||!!t1.immutable$list)&&!t1.is$JavaScriptIndexingBehavior())return this.operator$indexSet$2$bailout(4,key,value,t1,index);if(index<0||index>=t1.length)throw $.ioore(index);t1[index]=key;t1=this._values;if(typeof t1!=='object'||t1===null||(t1.constructor!==Array||!!t1.immutable$list)&&!t1.is$JavaScriptIndexingBehavior())return this.operator$indexSet$2$bailout(5,value,t1,index,0);if(index<0||index>=t1.length)throw $.ioore(index);t1[index]=value;},
 operator$indexSet$2$bailout: function(state,env0,env1,env2,env3){switch(state){case 1:var key=env0;var value=env1;index=env2;t1=env3;break;case 2:key=env0;value=env1;index=env2;t1=env3;break;case 3:key=env0;value=env1;t1=env2;index=env3;break;case 4:key=env0;value=env1;t1=env2;index=env3;break;case 5:value=env0;t1=env1;index=env2;break;}switch(state){case 0:this._ensureCapacity$0();var index=this._probeForAdding$1(key);var t1=this._keys;case 1:state=0;case 2:if(state===2||state===0&&!($.index(t1,index)==null))switch(state){case 0:t1=this._keys;case 2:state=0;var t3=$.index(t1,index)===$.CTC13;t1=t3;}else t1=true;case 3:if(state===3||state===0&&t1)switch(state){case 0:t1=this._numberOfEntries;case 3:state=0;this._numberOfEntries=$.add(t1,1);}t1=this._keys;case 4:state=0;$.indexSet(t1,index,key);t1=this._values;case 5:state=0;$.indexSet(t1,index,value);}},
 operator$index$1: function(key){var index=this._probeForLookup$1(key);if($.ltB(index,0))return;return $.index(this._values,index);},
 putIfAbsent$2: function(key,ifAbsent){var index=this._probeForLookup$1(key);if(typeof index!=='number')return this.putIfAbsent$2$bailout(1,key,ifAbsent,index);if(index>=0){var t1=this._values;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.putIfAbsent$2$bailout(2,index,t1,0);if(index!==(index|0))throw $.iae(index);if(index<0||index>=t1.length)throw $.ioore(index);return t1[index];}var value=ifAbsent.call$0();this.operator$indexSet$2(key,value);return value;},
 putIfAbsent$2$bailout: function(state,env0,env1,env2){switch(state){case 1:var key=env0;var ifAbsent=env1;index=env2;break;case 2:index=env0;t1=env1;break;}switch(state){case 0:var index=this._probeForLookup$1(key);case 1:state=0;case 2:if(state===2||state===0&&$.geB(index,0))switch(state){case 0:var t1=this._values;case 2:state=0;return $.index(t1,index);}var value=ifAbsent.call$0();this.operator$indexSet$2(key,value);return value;}},
 remove$1: function(key){var index=this._probeForLookup$1(key);if($.geB(index,0)){this._numberOfEntries=$.sub(this._numberOfEntries,1);var value=$.index(this._values,index);$.indexSet(this._values,index,null);$.indexSet(this._keys,index,$.CTC13);this._numberOfDeleted=$.add(this._numberOfDeleted,1);return value;}return;},
 isEmpty$0: function(){return $.eq(this._numberOfEntries,0);},
 get$length: function(){return this._numberOfEntries;},
 forEach$1: function(f){var length$=$.get$length(this._keys);if(typeof length$!=='number')return this.forEach$1$bailout(1,f,length$);for(var i=0;i<length$;++i){var key=$.index(this._keys,i);if(!(key==null)&&!(key===$.CTC13))f.call$2(key,$.index(this._values,i));}},
 forEach$1$bailout: function(state,f,length$){for(var i=0;$.ltB(i,length$);++i){var key=$.index(this._keys,i);if(!(key==null)&&!(key===$.CTC13))f.call$2(key,$.index(this._values,i));}},
 getKeys$0: function(){var t1={};var list=$.ListImplementation_List($.get$length(this),$.getRuntimeTypeInfo(this).K);t1.i_10=0;this.forEach$1(new $.HashMapImplementation_getKeys__(list,t1));return list;},
 getValues$0: function(){var t1={};var list=$.ListImplementation_List($.get$length(this),$.getRuntimeTypeInfo(this).V);t1.i_1=0;this.forEach$1(new $.HashMapImplementation_getValues__(list,t1));return list;},
 containsKey$1: function(key){return !$.eqB(this._probeForLookup$1(key),-1);},
 toString$0: function(){return $.Maps_mapToString(this);},
 HashMapImplementation$0: function(){this._numberOfEntries=0;this._numberOfDeleted=0;this._loadLimit=$.HashMapImplementation__computeLoadLimit(8);this._keys=$.ListImplementation_List(8);this._values=$.ListImplementation_List(8,$.getRuntimeTypeInfo(this).V);},
 is$Map: function() { return true; }
};

$$.HashSetImplementation = {"":
 ["_backingMap?"],
 "super": "Object",
 clear$0: function(){$.clear(this._backingMap);},
 add$1: function(value){var t1=this._backingMap;if(typeof t1!=='object'||t1===null||(t1.constructor!==Array||!!t1.immutable$list)&&!t1.is$JavaScriptIndexingBehavior())return this.add$1$bailout(1,t1,value);if(value!==(value|0))throw $.iae(value);if(value<0||value>=t1.length)throw $.ioore(value);t1[value]=value;},
 add$1$bailout: function(state,t1,value){$.indexSet(t1,value,value);},
 remove$1: function(value){var t1=this._backingMap;if(t1.containsKey$1(value)!==true)return false;t1.remove$1(value);return true;},
 addAll$1: function(collection){$.forEach(collection,new $.HashSetImplementation_addAll__(this));},
 forEach$1: function(f){$.forEach(this._backingMap,new $.HashSetImplementation_forEach__(f));},
 filter$1: function(f){var result=$.HashSetImplementation$($.getRuntimeTypeInfo(this).E);$.forEach(this._backingMap,new $.HashSetImplementation_filter__(f,result));return result;},
 isEmpty$0: function(){return $.isEmpty(this._backingMap);},
 get$length: function(){return $.get$length(this._backingMap);},
 iterator$0: function(){return $.HashSetIterator$(this,$.getRuntimeTypeInfo(this).E);},
 toString$0: function(){return $.Collections_collectionToString(this);},
 HashSetImplementation$0: function(){this._backingMap=$.HashMapImplementation$($.getRuntimeTypeInfo(this).E,$.getRuntimeTypeInfo(this).E);},
 is$Collection: function() { return true; }
};

$$.HashSetIterator = {"":
 ["_entries", "_nextValidIndex"],
 "super": "Object",
 hasNext$0: function(){var t1=this._nextValidIndex;var t2=this._entries;if(typeof t2!=='string'&&(typeof t2!=='object'||t2===null||t2.constructor!==Array&&!t2.is$JavaScriptIndexingBehavior()))return this.hasNext$0$bailout(1,t1,t2);var t4=t2.length;if(t1>=t4)return false;if(t1!==(t1|0))throw $.iae(t1);if(t1<0||t1>=t4)throw $.ioore(t1);if(t2[t1]===$.CTC13)this._advance$0();return this._nextValidIndex<t2.length;},
 hasNext$0$bailout: function(state,t1,t2){if($.geB(t1,$.get$length(t2)))return false;if($.index(t2,this._nextValidIndex)===$.CTC13)this._advance$0();return $.lt(this._nextValidIndex,$.get$length(t2));},
 next$0: function(){if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);var t1=this._entries;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.next$0$bailout(1,t1);var t3=this._nextValidIndex;if(t3!==(t3|0))throw $.iae(t3);if(t3<0||t3>=t1.length)throw $.ioore(t3);var res=t1[t3];this._advance$0();return res;},
 next$0$bailout: function(state,t1){var res=$.index(t1,this._nextValidIndex);this._advance$0();return res;},
 _advance$0: function(){var t1=this._entries;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this._advance$0$bailout(1,t1);var length$=t1.length;var entry=null;do{var t2=this._nextValidIndex+1;this._nextValidIndex=t2;if(t2>=length$)break;t2=this._nextValidIndex;if(t2!==(t2|0))throw $.iae(t2);if(t2<0||t2>=t1.length)throw $.ioore(t2);entry=t1[t2];}while(entry==null||entry===$.CTC13);},
 _advance$0$bailout: function(state,t1){var length$=$.get$length(t1);var entry=null;do{var t2=this._nextValidIndex+1;this._nextValidIndex=t2;if($.geB(t2,length$))break;entry=$.index(t1,this._nextValidIndex);}while(entry==null||entry===$.CTC13);},
 HashSetIterator$1: function(set_){this._advance$0();}
};

$$._DeletedKeySentinel = {"":
 [],
 "super": "Object"
};

$$.KeyValuePair = {"":
 ["key?", "value="],
 "super": "Object"
};

$$.LinkedHashMapImplementation = {"":
 ["_list", "_map"],
 "super": "Object",
 operator$indexSet$2: function(key,value){var t1=this._map;if(typeof t1!=='object'||t1===null||(t1.constructor!==Array||!!t1.immutable$list)&&!t1.is$JavaScriptIndexingBehavior())return this.operator$indexSet$2$bailout(1,key,value,t1);if(t1.containsKey$1(key)===true){if(key!==(key|0))throw $.iae(key);if(key<0||key>=t1.length)throw $.ioore(key);t1[key].get$element().set$value(value);}else{var t2=this._list;$.addLast(t2,$.KeyValuePair$(key,value,$.getRuntimeTypeInfo(this).K,$.getRuntimeTypeInfo(this).V));t2=t2.lastEntry$0();if(key!==(key|0))throw $.iae(key);if(key<0||key>=t1.length)throw $.ioore(key);t1[key]=t2;}},
 operator$indexSet$2$bailout: function(state,key,value,t1){if(t1.containsKey$1(key)===true)$.index(t1,key).get$element().set$value(value);else{var t2=this._list;$.addLast(t2,$.KeyValuePair$(key,value,$.getRuntimeTypeInfo(this).K,$.getRuntimeTypeInfo(this).V));$.indexSet(t1,key,t2.lastEntry$0());}},
 operator$index$1: function(key){var entry=$.index(this._map,key);if(entry==null)return;return entry.get$element().get$value();},
 remove$1: function(key){var entry=this._map.remove$1(key);if(entry==null)return;entry.remove$0();return entry.get$element().get$value();},
 putIfAbsent$2: function(key,ifAbsent){var value=this.operator$index$1(key);if(this.operator$index$1(key)==null&&this.containsKey$1(key)!==true){value=ifAbsent.call$0();this.operator$indexSet$2(key,value);}return value;},
 getKeys$0: function(){var t1={};var list=$.ListImplementation_List($.get$length(this),$.getRuntimeTypeInfo(this).K);t1.index_10=0;$.forEach(this._list,new $.LinkedHashMapImplementation_getKeys__(list,t1));return list;},
 getValues$0: function(){var t1={};var list=$.ListImplementation_List($.get$length(this),$.getRuntimeTypeInfo(this).V);t1.index_1=0;$.forEach(this._list,new $.LinkedHashMapImplementation_getValues__(list,t1));return list;},
 forEach$1: function(f){$.forEach(this._list,new $.LinkedHashMapImplementation_forEach__(f));},
 containsKey$1: function(key){return this._map.containsKey$1(key);},
 get$length: function(){return $.get$length(this._map);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 clear$0: function(){$.clear(this._map);$.clear(this._list);},
 toString$0: function(){return $.Maps_mapToString(this);},
 LinkedHashMapImplementation$0: function(){this._map=$.HashMapImplementation$($.getRuntimeTypeInfo(this).K,'DoubleLinkedQueueEntry<KeyValuePair<K, V>>');this._list=$.DoubleLinkedQueue$('KeyValuePair<K, V>');},
 is$Map: function() { return true; }
};

$$.DoubleLinkedQueueEntry = {"":
 ["_previous=", "_next=", "_lib0_element?"],
 "super": "Object",
 _link$2: function(p,n){this._next=n;this._previous=p;p.set$_next(this);n.set$_previous(this);},
 prepend$1: function(e){$.DoubleLinkedQueueEntry$(e,$.getRuntimeTypeInfo(this).E)._link$2(this._previous,this);},
 remove$0: function(){var t1=this._next;this._previous.set$_next(t1);t1=this._previous;this._next.set$_previous(t1);this._next=null;this._previous=null;return this._lib0_element;},
 _asNonSentinelEntry$0: function(){return this;},
 previousEntry$0: function(){return this._previous._asNonSentinelEntry$0();},
 get$element: function(){return this._lib0_element;},
 DoubleLinkedQueueEntry$1: function(e){this._lib0_element=e;}
};

$$._DoubleLinkedQueueEntrySentinel = {"":
 ["_previous", "_next", "_lib0_element"],
 "super": "DoubleLinkedQueueEntry",
 remove$0: function(){throw $.$$throw($.CTC14);},
 _asNonSentinelEntry$0: function(){return;},
 get$element: function(){throw $.$$throw($.CTC14);},
 _DoubleLinkedQueueEntrySentinel$0: function(){this._link$2(this,this);}
};

$$.DoubleLinkedQueue = {"":
 ["_sentinel"],
 "super": "Object",
 addLast$1: function(value){this._sentinel.prepend$1(value);},
 add$1: function(value){this.addLast$1(value);},
 addAll$1: function(collection){for(var t1=$.iterator(collection);t1.hasNext$0()===true;)this.add$1(t1.next$0());},
 removeLast$0: function(){return this._sentinel.get$_previous().remove$0();},
 removeFirst$0: function(){return this._sentinel.get$_next().remove$0();},
 first$0: function(){return this._sentinel.get$_next().get$element();},
 get$first: function() { return new $.BoundClosure(this, 'first$0'); },
 last$0: function(){return this._sentinel.get$_previous().get$element();},
 lastEntry$0: function(){return this._sentinel.previousEntry$0();},
 get$length: function(){var t1={};t1.counter_1=0;this.forEach$1(new $.DoubleLinkedQueue_length__(t1));return t1.counter_1;},
 isEmpty$0: function(){var t1=this._sentinel;var t2=t1.get$_next();return t2==null?t1==null:t2===t1;},
 clear$0: function(){var t1=this._sentinel;t1.set$_next(t1);t1.set$_previous(t1);},
 forEach$1: function(f){var t1=this._sentinel;var entry=t1.get$_next();for(;!(entry==null?t1==null:entry===t1);){var nextEntry=entry.get$_next();f.call$1(entry.get$_lib0_element());entry=nextEntry;}},
 filter$1: function(f){var other=$.DoubleLinkedQueue$($.getRuntimeTypeInfo(this).E);var t1=this._sentinel;var entry=t1.get$_next();for(;!(entry==null?t1==null:entry===t1);){var nextEntry=entry.get$_next();if(f.call$1(entry.get$_lib0_element())===true)other.addLast$1(entry.get$_lib0_element());entry=nextEntry;}return other;},
 iterator$0: function(){return $._DoubleLinkedQueueIterator$(this._sentinel,$.getRuntimeTypeInfo(this).E);},
 toString$0: function(){return $.Collections_collectionToString(this);},
 DoubleLinkedQueue$0: function(){this._sentinel=$._DoubleLinkedQueueEntrySentinel$($.getRuntimeTypeInfo(this).E);},
 is$Collection: function() { return true; }
};

$$._DoubleLinkedQueueIterator = {"":
 ["_sentinel", "_currentEntry"],
 "super": "Object",
 hasNext$0: function(){var t1=this._currentEntry.get$_next();var t2=this._sentinel;return !(t1==null?t2==null:t1===t2);},
 next$0: function(){if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);this._currentEntry=this._currentEntry.get$_next();return this._currentEntry.get$element();},
 _DoubleLinkedQueueIterator$1: function(_sentinel){this._currentEntry=this._sentinel;}
};

$$.JSSyntaxRegExp = {"":
 ["_ignoreCase", "_multiLine", "_lib0_pattern"],
 "super": "Object",
 firstMatch$1: function(str){var m=$.regExpExec(this,$.checkString(str));if(m==null)return;var matchStart=$.regExpMatchStart(m);var t1=$.get$length($.index(m,0));if(typeof t1!=='number')throw $.iae(t1);var matchEnd=matchStart+t1;return $._MatchImplementation$(this.get$pattern(),str,matchStart,matchEnd,m);},
 hasMatch$1: function(str){return $.regExpTest(this,$.checkString(str));},
 get$pattern: function(){return this._lib0_pattern;},
 get$multiLine: function(){return this._multiLine;},
 get$ignoreCase: function(){return this._ignoreCase;},
 is$JSSyntaxRegExp: true,
 is$RegExp: true
};

$$.StringBufferImpl = {"":
 ["_buffer", "_length"],
 "super": "Object",
 get$length: function(){return this._length;},
 isEmpty$0: function(){return this._length===0;},
 add$1: function(obj){var str=$.toString(obj);if(str==null||$.isEmpty(str)===true)return this;$.add$1(this._buffer,str);var t1=this._length;if(typeof t1!=='number')return this.add$1$bailout(1,str,t1);var t3=$.get$length(str);if(typeof t3!=='number')return this.add$1$bailout(2,t1,t3);this._length=t1+t3;return this;},
 add$1$bailout: function(state,env0,env1){switch(state){case 1:str=env0;t1=env1;break;case 2:t1=env0;t3=env1;break;}switch(state){case 0:var str=$.toString(obj);if(str==null||$.isEmpty(str)===true)return this;$.add$1(this._buffer,str);var t1=this._length;case 1:state=0;var t3=$.get$length(str);case 2:state=0;this._length=$.add(t1,t3);return this;}},
 addAll$1: function(objects){for(var t1=$.iterator(objects);t1.hasNext$0()===true;)this.add$1(t1.next$0());return this;},
 clear$0: function(){this._buffer=$.ListImplementation_List(null,'String');this._length=0;return this;},
 toString$0: function(){if($.get$length(this._buffer)===0)return '';if($.get$length(this._buffer)===1)return $.index(this._buffer,0);var result=$.stringJoinUnchecked($.StringImplementation__toJsStringArray(this._buffer),'');$.clear(this._buffer);$.add$1(this._buffer,result);return result;},
 StringBufferImpl$1: function(content$){this.clear$0();this.add$1(content$);}
};

$$._MatchImplementation = {"":
 ["pattern", "str", "_start", "_end", "_groups"],
 "super": "Object",
 group$1: function(index){return $.index(this._groups,index);},
 operator$index$1: function(index){return this.group$1(index);}
};

$$.IndexOutOfRangeException = {"":
 ["_value?"],
 "super": "Object",
 toString$0: function(){return 'IndexOutOfRangeException: '+$.S(this._value);},
 is$Exception: true
};

$$.IllegalAccessException = {"":
 [],
 "super": "Object",
 toString$0: function(){return 'Attempt to modify an immutable object';},
 is$Exception: true
};

$$.NoSuchMethodException = {"":
 ["_receiver", "_functionName", "_arguments", "_existingArgumentNames"],
 "super": "Object",
 toString$0: function(){var sb=$.StringBufferImpl$('');var t1=this._arguments;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.toString$0$bailout(1,t1,sb);var i=0;for(;i<t1.length;++i){if(i>0)sb.add$1(', ');if(i<0||i>=t1.length)throw $.ioore(i);sb.add$1(t1[i]);}t1=this._existingArgumentNames;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.toString$0$bailout(2,sb,t1);var actualParameters=sb.toString$0();sb=$.StringBufferImpl$('');for(i=0;i<t1.length;++i){if(i>0)sb.add$1(', ');if(i<0||i>=t1.length)throw $.ioore(i);sb.add$1(t1[i]);}var formalParameters=sb.toString$0();t1=this._functionName;return 'NoSuchMethodException: incorrect number of arguments passed to method named \''+$.S(t1)+'\'\nReceiver: '+$.S(this._receiver)+'\n'+'Tried calling: '+$.S(t1)+'('+$.S(actualParameters)+')\n'+'Found: '+$.S(t1)+'('+$.S(formalParameters)+')';},
 toString$0$bailout: function(state,env0,env1){switch(state){case 1:t1=env0;sb=env1;break;case 2:sb=env0;t1=env1;break;}switch(state){case 0:var sb=$.StringBufferImpl$('');var t1=this._arguments;case 1:state=0;var i=0;for(;$.ltB(i,$.get$length(t1));++i){if(i>0)sb.add$1(', ');sb.add$1($.index(t1,i));}t1=this._existingArgumentNames;case 2:state=0;if(t1==null)return 'NoSuchMethodException : method not found: \''+$.S(this._functionName)+'\'\n'+'Receiver: '+$.S(this._receiver)+'\n'+'Arguments: ['+$.S(sb)+']';else{var actualParameters=sb.toString$0();sb=$.StringBufferImpl$('');for(i=0;$.ltB(i,$.get$length(t1));++i){if(i>0)sb.add$1(', ');sb.add$1($.index(t1,i));}var formalParameters=sb.toString$0();t1=this._functionName;return 'NoSuchMethodException: incorrect number of arguments passed to method named \''+$.S(t1)+'\'\nReceiver: '+$.S(this._receiver)+'\n'+'Tried calling: '+$.S(t1)+'('+$.S(actualParameters)+')\n'+'Found: '+$.S(t1)+'('+$.S(formalParameters)+')';}}},
 is$Exception: true
};

$$.ObjectNotClosureException = {"":
 [],
 "super": "Object",
 toString$0: function(){return 'Object is not closure';},
 is$Exception: true
};

$$.IllegalArgumentException = {"":
 ["_arg"],
 "super": "Object",
 toString$0: function(){return 'Illegal argument(s): '+$.S(this._arg);},
 is$Exception: true
};

$$.StackOverflowException = {"":
 [],
 "super": "Object",
 toString$0: function(){return 'Stack Overflow';},
 is$Exception: true
};

$$.FormatException = {"":
 ["message?"],
 "super": "Object",
 toString$0: function(){return 'FormatException: '+$.S(this.message);},
 is$Exception: true
};

$$.NullPointerException = {"":
 ["functionName", "arguments"],
 "super": "Object",
 toString$0: function(){var t1=this.functionName;if(t1==null)return this.get$exceptionName();else return $.S(this.get$exceptionName())+' : method: \''+$.S(t1)+'\'\n'+'Receiver: null\n'+'Arguments: '+$.S(this.arguments);},
 get$exceptionName: function(){return 'NullPointerException';},
 is$Exception: true
};

$$.NoMoreElementsException = {"":
 [],
 "super": "Object",
 toString$0: function(){return 'NoMoreElementsException';},
 is$Exception: true
};

$$.EmptyQueueException = {"":
 [],
 "super": "Object",
 toString$0: function(){return 'EmptyQueueException';},
 is$Exception: true
};

$$.UnsupportedOperationException = {"":
 ["_message"],
 "super": "Object",
 toString$0: function(){return 'UnsupportedOperationException: '+$.S(this._message);},
 is$Exception: true
};

$$.NotImplementedException = {"":
 ["_message"],
 "super": "Object",
 toString$0: function(){var t1=this._message;return !(t1==null)?'NotImplementedException: '+$.S(t1):'NotImplementedException';},
 is$Exception: true
};

$$.IllegalJSRegExpException = {"":
 ["_pattern", "_errmsg"],
 "super": "Object",
 toString$0: function(){return 'IllegalJSRegExpException: \''+$.S(this._pattern)+'\' \''+$.S(this._errmsg)+'\'';},
 is$Exception: true
};

$$.FutureNotCompleteException = {"":
 [],
 "super": "Object",
 toString$0: function(){return 'Exception: future has not been completed';},
 is$Exception: true
};

$$.FutureAlreadyCompleteException = {"":
 [],
 "super": "Object",
 toString$0: function(){return 'Exception: future already completed';},
 is$Exception: true
};

$$.Object = {"":
 [],
 "super": "",
 operator$eq$1: function(other){return this===other;},
 toString$0: function(){return $.Primitives_objectToString(this);}
};

$$._Random = {"":
 [],
 "super": "Object",
 nextDouble$0: function(){return Math.random();},
 nextBool$0: function(){return Math.random() < 0.5;}
};

$$.ListIterator = {"":
 ["i", "list"],
 "super": "Object",
 hasNext$0: function(){var t1=this.i;if(typeof t1!=='number')return this.hasNext$0$bailout(1,t1);return t1<this.list.length;},
 hasNext$0$bailout: function(state,t1){return $.lt(t1,this.list.length);},
 next$0: function(){if(this.hasNext$0()!==true)throw $.$$throw($.NoMoreElementsException$());var value=this.list[this.i];var t1=this.i;if(typeof t1!=='number')return this.next$0$bailout(1,t1,value);this.i=t1+1;return value;},
 next$0$bailout: function(state,t1,value){this.i=$.add(t1,1);return value;}
};

$$.StackTrace = {"":
 ["stack"],
 "super": "Object",
 toString$0: function(){var t1=this.stack;return !(t1==null)?t1:'';}
};

$$.Closure = {"":
 [],
 "super": "Object",
 toString$0: function(){return 'Closure';},
 is$Function: true
};

$$.ConstantMap = {"":
 ["length?", "_jsObject", "_lib5_keys?"],
 "super": "Object",
 containsKey$1: function(key){if($.eqB(key,'__proto__'))return false;return $.jsHasOwnProperty(this._jsObject,key);},
 operator$index$1: function(key){if(this.containsKey$1(key)!==true)return;return this._jsObject[key];},
 forEach$1: function(f){$.forEach(this._lib5_keys,new $.ConstantMap_forEach_anon(this,f));},
 getKeys$0: function(){return this._lib5_keys;},
 getValues$0: function(){var result=[];$.forEach(this._lib5_keys,new $.ConstantMap_getValues_anon(this,result));return result;},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 toString$0: function(){return $.Maps_mapToString(this);},
 _throwImmutable$0: function(){throw $.$$throw($.CTC35);},
 operator$indexSet$2: function(key,val){return this._throwImmutable$0();},
 putIfAbsent$2: function(key,ifAbsent){return this._throwImmutable$0();},
 remove$1: function(key){return this._throwImmutable$0();},
 clear$0: function(){return this._throwImmutable$0();},
 is$Map: function() { return true; }
};

$$.MetaInfo = {"":
 ["_tag?", "_tags", "_lib5_set?"],
 "super": "Object",
 _lib5_set$2: function(arg0, arg1) { return this._lib5_set.call$2(arg0, arg1); }
};

$$.VoteDemo = {"":
 ["_canvas", "_stage", "_dragger", "_calcEngine?", "_rootMapElement?", "_playerHues", "_condorcetView?", "_distanceView", "_pluralityView", "_canManView", "_candidateHues", "_mouseLocation", "_overCandidate", "_dragCandidate", "_frameRequested"],
 "super": "Object",
 _locationDataUpdated$1: function(args){var locData=this._calcEngine.get$locationData();this._rootMapElement.set$locationData(locData);var t1=locData.get$candidates();this._canManView.set$candidates(t1);},
 get$_locationDataUpdated: function() { return new $.BoundClosure0(this, '_locationDataUpdated$1'); },
 _distanceElectionUpdated$1: function(args){var t1=this._calcEngine.get$distanceElection();this._distanceView.set$election(t1);this._requestFrame$0();},
 get$_distanceElectionUpdated: function() { return new $.BoundClosure0(this, '_distanceElectionUpdated$1'); },
 _pluralityElectionUpdated$1: function(args){var t1=this._calcEngine.get$pluralityElection();this._pluralityView.set$election(t1);this._requestFrame$0();},
 get$_pluralityElectionUpdated: function() { return new $.BoundClosure0(this, '_pluralityElectionUpdated$1'); },
 _condorcetElectionUpdated$1: function(args){var t1=this._calcEngine.get$condorcetElection();this._condorcetView.set$election(t1);this._requestFrame$0();},
 get$_condorcetElectionUpdated: function() { return new $.BoundClosure0(this, '_condorcetElectionUpdated$1'); },
 _voterHexMapperUpdated$1: function(args){var t1=this._calcEngine.get$voterHexMap();this._rootMapElement.set$voterHexMap(t1);this._requestFrame$0();},
 get$_voterHexMapperUpdated: function() { return new $.BoundClosure0(this, '_voterHexMapperUpdated$1'); },
 _requestFrame$0: function(){if(this._frameRequested!==true){this._frameRequested=true;$.window().requestAnimationFrame$1(this.get$_onFrame());}},
 _onDrag$1: function(delta){this._rootMapElement.dragCandidate$2(this._dragCandidate,delta);this._requestFrame$0();},
 get$_onDrag: function() { return new $.BoundClosure0(this, '_onDrag$1'); },
 _onDragStart$1: function(e){var t1=this._overCandidate;if(t1==null)e.cancel$0();else this._dragCandidate=t1;},
 get$_onDragStart: function() { return new $.BoundClosure0(this, '_onDragStart$1'); },
 _onFrame$1: function(highResTime){this._stage.draw$0();this._condorcetView.draw$0();this._pluralityView.draw$0();this._distanceView.draw$0();this._canManView.draw$0();this._frameRequested=false;},
 get$_onFrame: function() { return new $.BoundClosure0(this, '_onFrame$1'); },
 _canvas_mouseMove$1: function(e){this._setMouse$1($.getMouseEventCoordinate(e));},
 get$_canvas_mouseMove: function() { return new $.BoundClosure0(this, '_canvas_mouseMove$1'); },
 _canvas_mouseOut$1: function(e){this._setMouse$1(null);},
 get$_canvas_mouseOut: function() { return new $.BoundClosure0(this, '_canvas_mouseOut$1'); },
 _setMouse$1: function(value){this._mouseLocation=value;var hits=$.Mouse_markMouseOver(this._stage,this._mouseLocation);if(!(hits==null))if($.gtB($.get$length(hits),0)){var t1=$.index(hits,0);t1=typeof t1==='object'&&t1!==null&&!!t1.is$CandidateElement;}else t1=false;else t1=false;if(t1){this._canvas.get$style().set$cursor('pointer');this._overCandidate=$.index(hits,0).get$player();}else this._overCandidate=null;t1=!(this._overCandidate==null)||!(this._dragCandidate==null);var t2=this._canvas;if(t1)t2.get$style().set$cursor('pointer');else t2.get$style().set$cursor('auto');},
 VoteDemo$_internal$8: function(_canvas,_stage,_dragger,_rootMapElement,_condorcetView,_pluralityView,_distanceView,_canManView){var t1=this._dragger;$.add$1(t1.get$dragDelta(),this.get$_onDrag());$.add$1(t1.get$dragStart(),this.get$_onDragStart());var t2=this._canvas;$.add$1(t2.get$on().get$mouseMove(),this.get$_canvas_mouseMove());$.add$1(t2.get$on().get$mouseOut(),this.get$_canvas_mouseOut());var t3=this._calcEngine;$.add$1(t3.get$locationDataChanged(),this.get$_locationDataUpdated());$.add$1(t3.get$distanceElectionChanged(),this.get$_distanceElectionUpdated());$.add$1(t3.get$pluralityElectionChanged(),this.get$_pluralityElectionUpdated());$.add$1(t3.get$condorcetElectionChanged(),this.get$_condorcetElectionUpdated());$.add$1(t3.get$voterHueMapperChanged(),this.get$_voterHexMapperUpdated());$.add$1(this._rootMapElement.get$candidatesMoved(),new $.anon1(this));$.add$1(this._stage.get$invalidated(),new $.anon2(this));var t4=this._canManView;$.add$1(t4.get$candidateRemoveRequest(),new $.anon3(this));$.add$1(t4.get$newCandidateRequest(),new $.anon4(this));$.add$1(this._condorcetView.get$hoverChanged(),new $.anon5(this));t3.set$locationData($.LocationData_LocationData$random());}
};

$$._AbstractWorkerEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._AudioContextEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$complete: function(){return this.operator$index$1('complete');},
 complete$1: function(arg0) { return this.get$complete().call$1(arg0); }
};

$$._BatteryManagerEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._BodyElementEventsImpl = {"":
 ["_ptr"],
 "super": "_ElementEventsImpl",
 get$blur: function(){return this.operator$index$1('blur');},
 get$message: function(){return this.operator$index$1('message');}
};

$$._DOMApplicationCacheEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._DedicatedWorkerContextEventsImpl = {"":
 ["_ptr"],
 "super": "_WorkerContextEventsImpl",
 get$message: function(){return this.operator$index$1('message');}
};

$$._DocumentEventsImpl = {"":
 ["_ptr"],
 "super": "_ElementEventsImpl",
 get$blur: function(){return this.operator$index$1('blur');},
 get$click: function(){return this.operator$index$1('click');},
 get$dragStart: function(){return this.operator$index$1('dragstart');},
 get$input: function(){return this.operator$index$1('input');},
 get$mouseDown: function(){return this.operator$index$1('mousedown');},
 get$mouseMove: function(){return this.operator$index$1('mousemove');},
 get$mouseOut: function(){return this.operator$index$1('mouseout');},
 get$mouseUp: function(){return this.operator$index$1('mouseup');},
 get$reset: function(){return this.operator$index$1('reset');},
 reset$0: function() { return this.get$reset().call$0(); },
 get$select: function(){return this.operator$index$1('select');},
 select$1: function(arg0) { return this.get$select().call$1(arg0); }
};

$$.FilteredElementList = {"":
 ["_lib_node", "_childNodes"],
 "super": "Object",
 get$_filtered: function(){return $.ListImplementation_List$from($.filter(this._childNodes,new $.FilteredElementList__filtered_anon()));},
 get$first: function(){for(var t1=$.iterator(this._childNodes);t1.hasNext$0()===true;){var t2=t1.next$0();if(typeof t2==='object'&&t2!==null&&t2.is$Element())return t2;}return;},
 first$0: function() { return this.get$first().call$0(); },
 forEach$1: function(f){$.forEach(this.get$_filtered(),f);},
 operator$indexSet$2: function(index,value){this.operator$index$1(index).replaceWith$1(value);},
 set$length: function(newLength){var len=$.get$length(this);if($.geB(newLength,len))return;else if($.ltB(newLength,0))throw $.$$throw($.CTC39);this.removeRange$2($.sub(newLength,1),$.sub(len,newLength));},
 add$1: function(value){$.add$1(this._childNodes,value);},
 get$add: function() { return new $.BoundClosure0(this, 'add$1'); },
 addAll$1: function(collection){$.forEach(collection,this.get$add());},
 addLast$1: function(value){this.add$1(value);},
 sort$1: function(compare){throw $.$$throw($.CTC37);},
 removeRange$2: function(start,rangeLength){$.forEach($.getRange(this.get$_filtered(),start,rangeLength),new $.FilteredElementList_removeRange_anon());},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC38);},
 clear$0: function(){$.clear(this._childNodes);},
 removeLast$0: function(){var result=this.last$0();if(!(result==null))result.remove$0();return result;},
 filter$1: function(f){return $.filter(this.get$_filtered(),f);},
 isEmpty$0: function(){return $.isEmpty(this.get$_filtered());},
 get$length: function(){return $.get$length(this.get$_filtered());},
 operator$index$1: function(index){return $.index(this.get$_filtered(),index);},
 iterator$0: function(){return $.iterator(this.get$_filtered());},
 getRange$2: function(start,rangeLength){return $.getRange(this.get$_filtered(),start,rangeLength);},
 indexOf$2: function(element,start){return $.indexOf$2(this.get$_filtered(),element,start);},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $.lastIndexOf$2(this.get$_filtered(),element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return $.last(this.get$_filtered());},
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$.EmptyElementRect = {"":
 ["client", "offset", "scroll", "bounding", "clientRects"],
 "super": "Object"
};

$$._FrozenCSSClassSet = {"":
 ["_lib_element"],
 "super": "_CssClassSet",
 _write$1: function(s){throw $.$$throw($.CTC33);},
 _read$0: function(){return $.HashSetImplementation$('String');}
};

$$._ChildrenElementList = {"":
 ["_lib_element?", "_childElements"],
 "super": "Object",
 _toList$0: function(){var t1=this._childElements;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this._toList$0$bailout(1,t1);var output=$.ListImplementation_List(t1.length);for(var len=t1.length,i=0;i<len;++i){if(i<0||i>=t1.length)throw $.ioore(i);var t2=t1[i];if(i<0||i>=output.length)throw $.ioore(i);output[i]=t2;}return output;},
 _toList$0$bailout: function(state,t1){var output=$.ListImplementation_List($.get$length(t1));for(var len=$.get$length(t1),i=0;$.ltB(i,len);++i){var t2=$.index(t1,i);if(i<0||i>=output.length)throw $.ioore(i);output[i]=t2;}return output;},
 get$first: function(){return this._lib_element.get$$$dom_firstElementChild();},
 first$0: function() { return this.get$first().call$0(); },
 forEach$1: function(f){for(var t1=$.iterator(this._childElements);t1.hasNext$0()===true;)f.call$1(t1.next$0());},
 filter$1: function(f){var output=[];this.forEach$1(new $._ChildrenElementList_filter_anon(f,output));return $._FrozenElementList$_wrap(output);},
 isEmpty$0: function(){return this._lib_element.get$$$dom_firstElementChild()==null;},
 get$length: function(){return $.get$length(this._childElements);},
 operator$index$1: function(index){return $.index(this._childElements,index);},
 operator$indexSet$2: function(index,value){this._lib_element.$dom_replaceChild$2(value,$.index(this._childElements,index));},
 set$length: function(newLength){throw $.$$throw($.CTC36);},
 add$1: function(value){this._lib_element.$dom_appendChild$1(value);return value;},
 addLast$1: function(value){return this.add$1(value);},
 iterator$0: function(){return $.iterator(this._toList$0());},
 addAll$1: function(collection){for(var t1=$.iterator(collection),t2=this._lib_element;t1.hasNext$0()===true;)t2.$dom_appendChild$1(t1.next$0());},
 sort$1: function(compare){throw $.$$throw($.CTC37);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC38);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC38);},
 getRange$2: function(start,rangeLength){return $._FrozenElementList$_wrap($._Lists_getRange(this,start,rangeLength,[]));},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 clear$0: function(){this._lib_element.set$text('');},
 removeLast$0: function(){var result=this.last$0();if(!(result==null))this._lib_element.$dom_removeChild$1(result);return result;},
 last$0: function(){return this._lib_element.get$$$dom_lastElementChild();},
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._FrozenElementList = {"":
 ["_nodeList"],
 "super": "Object",
 get$first: function(){var t1=this._nodeList;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.get$first$bailout(1,t1);if(0>=t1.length)throw $.ioore(0);return t1[0];},
 get$first$bailout: function(state,t1){return $.index(t1,0);},
 first$0: function() { return this.get$first().call$0(); },
 forEach$1: function(f){for(var t1=$.iterator(this);t1.hasNext$0()===true;)f.call$1(t1.next$0());},
 filter$1: function(f){var out=$._ElementList$([]);for(var t1=$.iterator(this);t1.hasNext$0()===true;){var t2=t1.next$0();if(f.call$1(t2)===true)out.add$1(t2);}return out;},
 isEmpty$0: function(){return $.isEmpty(this._nodeList);},
 get$length: function(){return $.get$length(this._nodeList);},
 operator$index$1: function(index){return $.index(this._nodeList,index);},
 operator$indexSet$2: function(index,value){throw $.$$throw($.CTC36);},
 set$length: function(newLength){$.set$length(this._nodeList,newLength);},
 add$1: function(value){throw $.$$throw($.CTC36);},
 addLast$1: function(value){throw $.$$throw($.CTC36);},
 iterator$0: function(){return $._FrozenElementListIterator$(this);},
 addAll$1: function(collection){throw $.$$throw($.CTC36);},
 sort$1: function(compare){throw $.$$throw($.CTC36);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC36);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC36);},
 getRange$2: function(start,rangeLength){return $._FrozenElementList$_wrap($.getRange(this._nodeList,start,rangeLength));},
 indexOf$2: function(element,start){return $.indexOf$2(this._nodeList,element,start);},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){return $.lastIndexOf$2(this._nodeList,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 clear$0: function(){throw $.$$throw($.CTC36);},
 removeLast$0: function(){throw $.$$throw($.CTC36);},
 last$0: function(){return $.last(this._nodeList);},
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._FrozenElementListIterator = {"":
 ["_lib_list", "_lib_index"],
 "super": "Object",
 next$0: function(){if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);var t1=this._lib_list;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.next$0$bailout(1,t1,0);var t3=this._lib_index;if(typeof t3!=='number')return this.next$0$bailout(2,t1,t3);this._lib_index=t3+1;if(t3!==(t3|0))throw $.iae(t3);if(t3<0||t3>=t1.length)throw $.ioore(t3);return t1[t3];},
 next$0$bailout: function(state,env0,env1){switch(state){case 1:t1=env0;break;case 2:t1=env0;t3=env1;break;}switch(state){case 0:if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);var t1=this._lib_list;case 1:state=0;var t3=this._lib_index;case 2:state=0;this._lib_index=$.add(t3,1);return $.index(t1,t3);}},
 hasNext$0: function(){var t1=this._lib_index;if(typeof t1!=='number')return this.hasNext$0$bailout(1,t1,0);var t3=$.get$length(this._lib_list);if(typeof t3!=='number')return this.hasNext$0$bailout(2,t1,t3);return t1<t3;},
 hasNext$0$bailout: function(state,env0,env1){switch(state){case 1:t1=env0;break;case 2:t1=env0;t3=env1;break;}switch(state){case 0:var t1=this._lib_index;case 1:state=0;var t3=$.get$length(this._lib_list);case 2:state=0;return $.lt(t1,t3);}}
};

$$._ElementList = {"":
 ["_lib_list"],
 "super": "_ListWrapper",
 filter$1: function(f){return $._ElementList$($._ListWrapper.prototype.filter$1.call(this,f));},
 getRange$2: function(start,rangeLength){return $._ElementList$($._ListWrapper.prototype.getRange$2.call(this,start,rangeLength));},
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._ElementAttributeMap = {"":
 ["_lib_element?"],
 "super": "Object",
 containsKey$1: function(key){return this._lib_element.$dom_hasAttribute$1(key);},
 operator$index$1: function(key){return this._lib_element.$dom_getAttribute$1(key);},
 operator$indexSet$2: function(key,value){this._lib_element.$dom_setAttribute$2(key,$.S(value));},
 putIfAbsent$2: function(key,ifAbsent){if(this.containsKey$1(key)!==true)this.operator$indexSet$2(key,ifAbsent.call$0());return this.operator$index$1(key);},
 remove$1: function(key){var t1=this._lib_element;var value=t1.$dom_getAttribute$1(key);t1.$dom_removeAttribute$1(key);return value;},
 clear$0: function(){var attributes=this._lib_element.get$$$dom_attributes();if(typeof attributes!=='string'&&(typeof attributes!=='object'||attributes===null||attributes.constructor!==Array&&!attributes.is$JavaScriptIndexingBehavior()))return this.clear$0$bailout(1,attributes);for(var i=attributes.length-1;i>=0;--i){if(i<0||i>=attributes.length)throw $.ioore(i);this.remove$1(attributes[i].get$name());}},
 clear$0$bailout: function(state,attributes){for(var i=$.sub($.get$length(attributes),1);$.geB(i,0);i=$.sub(i,1))this.remove$1($.index(attributes,i).get$name());},
 forEach$1: function(f){var attributes=this._lib_element.get$$$dom_attributes();if(typeof attributes!=='string'&&(typeof attributes!=='object'||attributes===null||attributes.constructor!==Array&&!attributes.is$JavaScriptIndexingBehavior()))return this.forEach$1$bailout(1,f,attributes);for(var len=attributes.length,i=0;i<len;++i){if(i<0||i>=attributes.length)throw $.ioore(i);var item=attributes[i];f.call$2(item.get$name(),item.get$value());}},
 forEach$1$bailout: function(state,f,attributes){for(var len=$.get$length(attributes),i=0;$.ltB(i,len);++i){var item=$.index(attributes,i);f.call$2(item.get$name(),item.get$value());}},
 getKeys$0: function(){var attributes=this._lib_element.get$$$dom_attributes();if(typeof attributes!=='string'&&(typeof attributes!=='object'||attributes===null||attributes.constructor!==Array&&!attributes.is$JavaScriptIndexingBehavior()))return this.getKeys$0$bailout(1,attributes);var keys=$.ListImplementation_List(attributes.length,'String');for(var len=attributes.length,i=0;i<len;++i){if(i<0||i>=attributes.length)throw $.ioore(i);var t1=attributes[i].get$name();if(i<0||i>=keys.length)throw $.ioore(i);keys[i]=t1;}return keys;},
 getKeys$0$bailout: function(state,attributes){var keys=$.ListImplementation_List($.get$length(attributes),'String');for(var len=$.get$length(attributes),i=0;$.ltB(i,len);++i){var t1=$.index(attributes,i).get$name();if(i<0||i>=keys.length)throw $.ioore(i);keys[i]=t1;}return keys;},
 getValues$0: function(){var attributes=this._lib_element.get$$$dom_attributes();if(typeof attributes!=='string'&&(typeof attributes!=='object'||attributes===null||attributes.constructor!==Array&&!attributes.is$JavaScriptIndexingBehavior()))return this.getValues$0$bailout(1,attributes);var values=$.ListImplementation_List(attributes.length,'String');for(var len=attributes.length,i=0;i<len;++i){if(i<0||i>=attributes.length)throw $.ioore(i);var t1=attributes[i].get$value();if(i<0||i>=values.length)throw $.ioore(i);values[i]=t1;}return values;},
 getValues$0$bailout: function(state,attributes){var values=$.ListImplementation_List($.get$length(attributes),'String');for(var len=$.get$length(attributes),i=0;$.ltB(i,len);++i){var t1=$.index(attributes,i).get$value();if(i<0||i>=values.length)throw $.ioore(i);values[i]=t1;}return values;},
 get$length: function(){return $.get$length(this._lib_element.get$$$dom_attributes());},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 is$Map: function() { return true; }
};

$$._DataAttributeMap = {"":
 ["$$dom_attributes?"],
 "super": "Object",
 containsKey$1: function(key){return this.$$dom_attributes.containsKey$1(this._attr$1(key));},
 operator$index$1: function(key){return $.index(this.$$dom_attributes,this._attr$1(key));},
 operator$indexSet$2: function(key,value){$.indexSet(this.$$dom_attributes,this._attr$1(key),$.S(value));},
 putIfAbsent$2: function(key,ifAbsent){return this.$$dom_attributes.putIfAbsent$2(this._attr$1(key),ifAbsent);},
 remove$1: function(key){return this.$$dom_attributes.remove$1(this._attr$1(key));},
 clear$0: function(){for(var t1=$.iterator(this.getKeys$0());t1.hasNext$0()===true;)this.remove$1(t1.next$0());},
 forEach$1: function(f){$.forEach(this.$$dom_attributes,new $._DataAttributeMap_forEach_anon(this,f));},
 getKeys$0: function(){var keys=$.ListImplementation_List(null,'String');$.forEach(this.$$dom_attributes,new $._DataAttributeMap_getKeys_anon(this,keys));return keys;},
 getValues$0: function(){var values=$.ListImplementation_List(null,'String');$.forEach(this.$$dom_attributes,new $._DataAttributeMap_getValues_anon(this,values));return values;},
 get$length: function(){return $.get$length(this.getKeys$0());},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 _attr$1: function(key){return 'data-'+$.S(key);},
 _matches$1: function(key){return $.startsWith(key,'data-');},
 _strip$1: function(key){return $.substring$1(key,5);},
 is$Map: function() { return true; }
};

$$._CssClassSet = {"":
 ["_lib_element?"],
 "super": "Object",
 toString$0: function(){return this._formatSet$1(this._read$0());},
 iterator$0: function(){return $.iterator(this._read$0());},
 forEach$1: function(f){$.forEach(this._read$0(),f);},
 filter$1: function(f){return $.filter(this._read$0(),f);},
 isEmpty$0: function(){return $.isEmpty(this._read$0());},
 get$length: function(){return $.get$length(this._read$0());},
 add$1: function(value){this._modify$1(new $._CssClassSet_add_anon(value));},
 remove$1: function(value){var s=this._read$0();var result=s.remove$1(value);this._write$1(s);return result;},
 addAll$1: function(collection){this._modify$1(new $._CssClassSet_addAll_anon(collection));},
 clear$0: function(){this._modify$1(new $._CssClassSet_clear_anon());},
 _modify$1: function(f){var s=this._read$0();f.call$1(s);this._write$1(s);},
 _read$0: function(){var s=$.HashSetImplementation$('String');for(var t1=$.iterator($.split(this._classname$0(),' '));t1.hasNext$0()===true;){var trimmed=$.trim(t1.next$0());if($.isEmpty(trimmed)!==true)s.add$1(trimmed);}return s;},
 _classname$0: function(){return this._lib_element.get$$$dom_className();},
 _write$1: function(s){var t1=this._formatSet$1(s);this._lib_element.set$$$dom_className(t1);},
 _formatSet$1: function(s){return $.Strings_join($.ListImplementation_List$from(s),' ');},
 is$Collection: function() { return true; }
};

$$._SimpleClientRect = {"":
 ["left?", "top?", "width?", "height?"],
 "super": "Object",
 operator$eq$1: function(other){return !(other==null)&&$.eqB(this.left,other.get$left())&&$.eqB(this.top,other.get$top())&&$.eqB(this.width,other.get$width())&&$.eqB(this.height,other.get$height());},
 toString$0: function(){return '('+$.S(this.left)+', '+$.S(this.top)+', '+$.S(this.width)+', '+$.S(this.height)+')';}
};

$$._ElementRectImpl = {"":
 ["client", "offset", "scroll", "_boundingClientRect", "_clientRects"],
 "super": "Object"
};

$$._ElementEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$blur: function(){return this.operator$index$1('blur');},
 get$click: function(){return this.operator$index$1('click');},
 get$dragStart: function(){return this.operator$index$1('dragstart');},
 get$input: function(){return this.operator$index$1('input');},
 get$mouseDown: function(){return this.operator$index$1('mousedown');},
 get$mouseMove: function(){return this.operator$index$1('mousemove');},
 get$mouseOut: function(){return this.operator$index$1('mouseout');},
 get$mouseUp: function(){return this.operator$index$1('mouseup');},
 get$reset: function(){return this.operator$index$1('reset');},
 reset$0: function() { return this.get$reset().call$0(); },
 get$select: function(){return this.operator$index$1('select');},
 select$1: function(arg0) { return this.get$select().call$1(arg0); }
};

$$._EventSourceEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$message: function(){return this.operator$index$1('message');}
};

$$._EventsImpl = {"":
 ["_ptr?"],
 "super": "Object",
 operator$index$1: function(type){return $._EventListenerListImpl$(this._ptr,type);}
};

$$._EventListenerListImpl = {"":
 ["_ptr?", "_type"],
 "super": "Object",
 add$2: function(listener,useCapture){this._add$2(listener,useCapture);return this;},
 add$1: function(listener) {
  return this.add$2(listener,false)
},
 remove$2: function(listener,useCapture){this._remove$2(listener,useCapture);return this;},
 remove$1: function(listener) {
  return this.remove$2(listener,false)
},
 _add$2: function(listener,useCapture){this._ptr.$dom_addEventListener$3(this._type,listener,useCapture);},
 _remove$2: function(listener,useCapture){this._ptr.$dom_removeEventListener$3(this._type,listener,useCapture);}
};

$$._FileReaderEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._FileWriterEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._FrameSetElementEventsImpl = {"":
 ["_ptr"],
 "super": "_ElementEventsImpl",
 get$blur: function(){return this.operator$index$1('blur');},
 get$message: function(){return this.operator$index$1('message');}
};

$$._HttpRequestEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._HttpRequestUploadEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._IDBDatabaseEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._IDBOpenDBRequestEventsImpl = {"":
 ["_ptr"],
 "super": "_IDBRequestEventsImpl"
};

$$._IDBRequestEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._IDBTransactionEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$complete: function(){return this.operator$index$1('complete');},
 complete$1: function(arg0) { return this.get$complete().call$1(arg0); }
};

$$._IDBVersionChangeRequestEventsImpl = {"":
 ["_ptr"],
 "super": "_IDBRequestEventsImpl"
};

$$._InputElementEventsImpl = {"":
 ["_ptr"],
 "super": "_ElementEventsImpl"
};

$$._JavaScriptAudioNodeEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._MediaElementEventsImpl = {"":
 ["_ptr"],
 "super": "_ElementEventsImpl"
};

$$._MediaStreamEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._MediaStreamTrackEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._MediaStreamTrackListEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._MessagePortEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$message: function(){return this.operator$index$1('message');}
};

$$._ChildNodeListLazy = {"":
 ["_this"],
 "super": "Object",
 get$first: function(){return this._this.firstChild;},
 first$0: function() { return this.get$first().call$0(); },
 last$0: function(){return this._this.lastChild;},
 add$1: function(value){this._this.$dom_appendChild$1(value);},
 addLast$1: function(value){this._this.$dom_appendChild$1(value);},
 addAll$1: function(collection){for(var t1=$.iterator(collection),t2=this._this;t1.hasNext$0()===true;)t2.$dom_appendChild$1(t1.next$0());},
 removeLast$0: function(){var result=this.last$0();if(!(result==null))this._this.$dom_removeChild$1(result);return result;},
 clear$0: function(){this._this.set$text('');},
 operator$indexSet$2: function(index,value){this._this.$dom_replaceChild$2(value,this.operator$index$1(index));},
 iterator$0: function(){return $.iterator(this._this.get$$$dom_childNodes());},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._NodeListWrapper$($._Collections_filter(this,[],f));},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.UnsupportedOperationException$('Cannot sort immutable List.'));},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,0)
},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.UnsupportedOperationException$('Cannot insertRange on immutable List.'));},
 getRange$2: function(start,rangeLength){return $._NodeListWrapper$($._Lists_getRange(this,start,rangeLength,[]));},
 get$length: function(){return $.get$length(this._this.get$$$dom_childNodes());},
 operator$index$1: function(index){return $.index(this._this.get$$$dom_childNodes(),index);},
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._ListWrapper = {"":
 [],
 "super": "Object",
 iterator$0: function(){return $.iterator(this._lib_list);},
 forEach$1: function(f){return $.forEach(this._lib_list,f);},
 filter$1: function(f){return $.filter(this._lib_list,f);},
 isEmpty$0: function(){return $.isEmpty(this._lib_list);},
 get$length: function(){return $.get$length(this._lib_list);},
 operator$index$1: function(index){return $.index(this._lib_list,index);},
 operator$indexSet$2: function(index,value){$.indexSet(this._lib_list,index,value);},
 set$length: function(newLength){$.set$length(this._lib_list,newLength);},
 add$1: function(value){return $.add$1(this._lib_list,value);},
 addLast$1: function(value){return $.addLast(this._lib_list,value);},
 addAll$1: function(collection){return $.addAll(this._lib_list,collection);},
 sort$1: function(compare){return $.sort(this._lib_list,compare);},
 indexOf$2: function(element,start){return $.indexOf$2(this._lib_list,element,start);},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){return $.lastIndexOf$2(this._lib_list,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,0)
},
 clear$0: function(){return $.clear(this._lib_list);},
 removeLast$0: function(){return $.removeLast(this._lib_list);},
 last$0: function(){return $.last(this._lib_list);},
 getRange$2: function(start,rangeLength){return $.getRange(this._lib_list,start,rangeLength);},
 removeRange$2: function(start,rangeLength){return $.removeRange(this._lib_list,start,rangeLength);},
 insertRange$3: function(start,rangeLength,initialValue){return $.insertRange$3(this._lib_list,start,rangeLength,initialValue);},
 get$first: function(){var t1=this._lib_list;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.get$first$bailout(1,t1);if(0>=t1.length)throw $.ioore(0);return t1[0];},
 get$first$bailout: function(state,t1){return $.index(t1,0);},
 first$0: function() { return this.get$first().call$0(); },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._NodeListWrapper = {"":
 ["_lib_list"],
 "super": "_ListWrapper",
 filter$1: function(f){return $._NodeListWrapper$($.filter(this._lib_list,f));},
 getRange$2: function(start,rangeLength){return $._NodeListWrapper$($.getRange(this._lib_list,start,rangeLength));},
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$._NotificationEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$click: function(){return this.operator$index$1('click');},
 get$close: function(){return this.operator$index$1('close');},
 close$0: function() { return this.get$close().call$0(); }
};

$$._PeerConnection00EventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._RTCPeerConnectionEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._AttributeClassSet = {"":
 ["_lib_element"],
 "super": "_CssClassSet",
 $dom_className$0: function(){return $.index(this._lib_element.get$attributes(),'class');},
 get$$$dom_className: function() { return new $.BoundClosure(this, '$dom_className$0'); },
 _write$1: function(s){$.indexSet(this._lib_element.get$attributes(),'class',this._formatSet$1(s));}
};

$$._SVGElementInstanceEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$blur: function(){return this.operator$index$1('blur');},
 get$click: function(){return this.operator$index$1('click');},
 get$dragStart: function(){return this.operator$index$1('dragstart');},
 get$input: function(){return this.operator$index$1('input');},
 get$mouseDown: function(){return this.operator$index$1('mousedown');},
 get$mouseMove: function(){return this.operator$index$1('mousemove');},
 get$mouseOut: function(){return this.operator$index$1('mouseout');},
 get$mouseUp: function(){return this.operator$index$1('mouseup');},
 get$reset: function(){return this.operator$index$1('reset');},
 reset$0: function() { return this.get$reset().call$0(); },
 get$select: function(){return this.operator$index$1('select');},
 select$1: function(arg0) { return this.get$select().call$1(arg0); }
};

$$._SharedWorkerContextEventsImpl = {"":
 ["_ptr"],
 "super": "_WorkerContextEventsImpl"
};

$$._SpeechRecognitionEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._TextTrackEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._TextTrackCueEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._TextTrackListEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._WebSocketEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$close: function(){return this.operator$index$1('close');},
 close$0: function() { return this.get$close().call$0(); },
 get$message: function(){return this.operator$index$1('message');}
};

$$._WindowEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl",
 get$blur: function(){return this.operator$index$1('blur');},
 get$click: function(){return this.operator$index$1('click');},
 get$dragStart: function(){return this.operator$index$1('dragstart');},
 get$input: function(){return this.operator$index$1('input');},
 get$message: function(){return this.operator$index$1('message');},
 get$mouseDown: function(){return this.operator$index$1('mousedown');},
 get$mouseMove: function(){return this.operator$index$1('mousemove');},
 get$mouseOut: function(){return this.operator$index$1('mouseout');},
 get$mouseUp: function(){return this.operator$index$1('mouseup');},
 get$reset: function(){return this.operator$index$1('reset');},
 reset$0: function() { return this.get$reset().call$0(); },
 get$select: function(){return this.operator$index$1('select');},
 select$1: function(arg0) { return this.get$select().call$1(arg0); }
};

$$._WorkerEventsImpl = {"":
 ["_ptr"],
 "super": "_AbstractWorkerEventsImpl",
 get$message: function(){return this.operator$index$1('message');}
};

$$._WorkerContextEventsImpl = {"":
 ["_ptr"],
 "super": "_EventsImpl"
};

$$._MeasurementRequest = {"":
 ["computeValue", "completer?", "value=", "exception="],
 "super": "Object",
 computeValue$0: function() { return this.computeValue.call$0(); }
};

$$._DOMWindowCrossFrameImpl = {"":
 ["_window"],
 "super": "Object",
 get$top: function(){return $._DOMWindowCrossFrameImpl__createSafe($._DOMWindowCrossFrameImpl__top(this._window));},
 blur$0: function(){return $._DOMWindowCrossFrameImpl__blur(this._window);},
 get$blur: function() { return new $.BoundClosure(this, 'blur$0'); },
 close$0: function(){return $._DOMWindowCrossFrameImpl__close(this._window);},
 postMessage$3: function(message,targetOrigin,messagePorts){var t1=messagePorts==null;var t2=this._window;if(t1)$._DOMWindowCrossFrameImpl__postMessage2(t2,message,targetOrigin);else $._DOMWindowCrossFrameImpl__postMessage3(t2,message,targetOrigin,messagePorts);},
 postMessage$2: function(message,targetOrigin) {
  return this.postMessage$3(message,targetOrigin,null)
}
};

$$._LocationWrapper = {"":
 ["_ptr?"],
 "super": "Object",
 toString$0: function(){return $._LocationWrapper__toString(this._ptr);},
 is$_LocationWrapper: true,
 is$Location: function() { return true; }
};

$$._FixedSizeListIterator = {"":
 ["_lib_length", "_array", "_pos"],
 "super": "_VariableSizeListIterator",
 hasNext$0: function(){var t1=this._lib_length;if(typeof t1!=='number')return this.hasNext$0$bailout(1,t1,0);var t3=this._pos;if(typeof t3!=='number')return this.hasNext$0$bailout(2,t1,t3);return t1>t3;},
 hasNext$0$bailout: function(state,env0,env1){switch(state){case 1:t1=env0;break;case 2:t1=env0;t3=env1;break;}switch(state){case 0:var t1=this._lib_length;case 1:state=0;var t3=this._pos;case 2:state=0;return $.gt(t1,t3);}}
};

$$._VariableSizeListIterator = {"":
 [],
 "super": "Object",
 hasNext$0: function(){var t1=$.get$length(this._array);if(typeof t1!=='number')return this.hasNext$0$bailout(1,t1,0);var t3=this._pos;if(typeof t3!=='number')return this.hasNext$0$bailout(2,t3,t1);return t1>t3;},
 hasNext$0$bailout: function(state,env0,env1){switch(state){case 1:t1=env0;break;case 2:t3=env0;t1=env1;break;}switch(state){case 0:var t1=$.get$length(this._array);case 1:state=0;var t3=this._pos;case 2:state=0;return $.gt(t1,t3);}},
 next$0: function(){if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);var t1=this._array;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.next$0$bailout(1,t1,0);var t3=this._pos;if(typeof t3!=='number')return this.next$0$bailout(2,t1,t3);this._pos=t3+1;if(t3!==(t3|0))throw $.iae(t3);if(t3<0||t3>=t1.length)throw $.ioore(t3);return t1[t3];},
 next$0$bailout: function(state,env0,env1){switch(state){case 1:t1=env0;break;case 2:t1=env0;t3=env1;break;}switch(state){case 0:if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);var t1=this._array;case 1:state=0;var t3=this._pos;case 2:state=0;this._pos=$.add(t3,1);return $.index(t1,t3);}}
};

$$._Manager = {"":
 ["nextIsolateId=", "currentManagerId=", "nextManagerId=", "currentContext=", "rootContext=", "topEventLoop?", "fromCommandLine?", "isWorker?", "supportsWorkers", "isolates?", "mainManager?", "managers?"],
 "super": "Object",
 get$useWorkers: function(){return this.supportsWorkers;},
 get$needSerialization: function(){return this.get$useWorkers();},
 _nativeDetectEnvironment$0: function(){    this.isWorker = $isWorker;
    this.supportsWorkers = $supportsWorkers;
    this.fromCommandLine = typeof(window) == 'undefined';
  },
 _nativeInitWorkerMessageHandler$0: function(){    $globalThis.onmessage = function (e) {
      _IsolateNatives._processWorkerMessage(this.mainManager, e);
    }
  },
 maybeCloseWorker$0: function(){if($.isEmpty(this.isolates)===true)this.mainManager.postMessage$1($._serializeMessage($.makeLiteralMap(['command','close'])));},
 _Manager$0: function(){this._nativeDetectEnvironment$0();this.topEventLoop=$._EventLoop$();this.isolates=$.HashMapImplementation$('int','_IsolateContext');this.managers=$.HashMapImplementation$('int','_ManagerStub');if(this.isWorker===true){this.mainManager=$._MainManagerStub$();this._nativeInitWorkerMessageHandler$0();}}
};

$$._IsolateContext = {"":
 ["id=", "ports?", "isolateStatics"],
 "super": "Object",
 initGlobals$0: function(){$initGlobals(this);},
 eval$1: function(code){var old=$._globalState().get$currentContext();$._globalState().set$currentContext(this);this._setGlobals$0();var result=null;try{result=code.call$0();}finally{var t1=old;$._globalState().set$currentContext(t1);t1=old;if(!(t1==null))t1._setGlobals$0();}return result;},
 _setGlobals$0: function(){$setGlobals(this);},
 lookup$1: function(portId){return $.index(this.ports,portId);},
 register$2: function(portId,port){var t1=this.ports;if(t1.containsKey$1(portId)===true)throw $.$$throw($.ExceptionImplementation$('Registry: ports must be registered only once.'));$.indexSet(t1,portId,port);$.indexSet($._globalState().get$isolates(),this.id,this);},
 unregister$1: function(portId){var t1=this.ports;t1.remove$1(portId);if($.isEmpty(t1)===true)$._globalState().get$isolates().remove$1(this.id);},
 _IsolateContext$0: function(){var t1=$._globalState();var t2=t1.get$nextIsolateId();t1.set$nextIsolateId($.add(t2,1));this.id=t2;this.ports=$.HashMapImplementation$('int','ReceivePort');this.initGlobals$0();}
};

$$._EventLoop = {"":
 ["events"],
 "super": "Object",
 enqueue$3: function(isolate,fn,msg){$.addLast(this.events,$._IsolateEvent$(isolate,fn,msg));},
 dequeue$0: function(){var t1=this.events;if($.isEmpty(t1)===true)return;return t1.removeFirst$0();},
 runIteration$0: function(){var event$=this.dequeue$0();if(event$==null){if($._globalState().get$isWorker()===true)$._globalState().maybeCloseWorker$0();else if(!($._globalState().get$rootContext()==null)&&$._globalState().get$isolates().containsKey$1($._globalState().get$rootContext().get$id())===true&&$._globalState().get$fromCommandLine()===true&&$.isEmpty($._globalState().get$rootContext().get$ports())===true)throw $.$$throw($.ExceptionImplementation$('Program exited with open ReceivePorts.'));return false;}event$.process$0();return true;},
 _runHelper$0: function(){if(!($._window()==null))new $._EventLoop__runHelper_next(this).call$0();else for(;this.runIteration$0()===true;);},
 run$0: function(){if($._globalState().get$isWorker()!==true)this._runHelper$0();else try{this._runHelper$0();}catch(exception){var t1=$.unwrapException(exception);var e=t1;var trace=$.getTraceFromException(exception);$._globalState().get$mainManager().postMessage$1($._serializeMessage($.makeLiteralMap(['command','error','msg',$.S(e)+'\n'+$.S(trace)])));}}
};

$$._IsolateEvent = {"":
 ["isolate", "fn", "message?"],
 "super": "Object",
 process$0: function(){this.isolate.eval$1(this.fn);}
};

$$._MainManagerStub = {"":
 [],
 "super": "Object",
 get$id: function(){return 0;},
 set$id: function(i){throw $.$$throw($.NotImplementedException$(null));},
 set$onmessage: function(f){throw $.$$throw($.ExceptionImplementation$('onmessage should not be set on MainManagerStub'));},
 postMessage$1: function(msg){$globalThis.postMessage(msg);},
 terminate$0: function(){}
};

$$._BaseSendPort = {"":
 ["_isolateId?"],
 "super": "Object",
 _checkReplyTo$1: function(replyTo){if(!(replyTo==null)&&!(typeof replyTo==='object'&&replyTo!==null&&!!replyTo.is$_NativeJsSendPort)&&!(typeof replyTo==='object'&&replyTo!==null&&!!replyTo.is$_WorkerSendPort)&&!(typeof replyTo==='object'&&replyTo!==null&&!!replyTo.is$_BufferingSendPort))throw $.$$throw($.ExceptionImplementation$('SendPort.send: Illegal replyTo port type'));},
 call$1: function(message){var completer=$.CompleterImpl$();var port=$._ReceivePortImpl$();this.send$2(message,port.toSendPort$0());port.receive$1(new $._BaseSendPort_call_anon(port,completer));return completer.get$future();},
 is$SendPort: true
};

$$._NativeJsSendPort = {"":
 ["_receivePort?", "_isolateId"],
 "super": "_BaseSendPort",
 send$2: function(message,replyTo){$._waitForPendingPorts([message,replyTo],new $._NativeJsSendPort_send_anon(this,message,replyTo));},
 send$1: function(message) {
  return this.send$2(message,null)
},
 operator$eq$1: function(other){return typeof other==='object'&&other!==null&&!!other.is$_NativeJsSendPort&&$.eqB(this._receivePort,other._receivePort);},
 hashCode$0: function(){return this._receivePort.get$_id();},
 is$_NativeJsSendPort: true,
 is$SendPort: true
};

$$._WorkerSendPort = {"":
 ["_workerId?", "_receivePortId", "_isolateId"],
 "super": "_BaseSendPort",
 send$2: function(message,replyTo){$._waitForPendingPorts([message,replyTo],new $._WorkerSendPort_send_anon(this,message,replyTo));},
 send$1: function(message) {
  return this.send$2(message,null)
},
 operator$eq$1: function(other){if(typeof other==='object'&&other!==null&&!!other.is$_WorkerSendPort)var t1=$.eqB(this._workerId,other._workerId)&&$.eqB(this._isolateId,other._isolateId)&&$.eqB(this._receivePortId,other._receivePortId);else t1=false;return t1;},
 hashCode$0: function(){return $.xor($.xor($.shl(this._workerId,16),$.shl(this._isolateId,8)),this._receivePortId);},
 is$_WorkerSendPort: true,
 is$SendPort: true
};

$$._BufferingSendPort = {"":
 ["_id?", "_port!", "_futurePort?", "pending=", "_isolateId"],
 "super": "_BaseSendPort",
 send$2: function(message,replyTo){var t1=this._port;if(!(t1==null))t1.send$2(message,replyTo);else $.add$1(this.pending,$.makeLiteralMap(['message',message,'replyTo',replyTo]));},
 send$1: function(message) {
  return this.send$2(message,null)
},
 operator$eq$1: function(other){return typeof other==='object'&&other!==null&&!!other.is$_BufferingSendPort&&$.eqB(this._id,other._id);},
 hashCode$0: function(){return this._id;},
 _BufferingSendPort$2: function(isolateId,_futurePort){$._BufferingSendPort__idCount=$.add($._BufferingSendPort__idCount,1);this._futurePort.then$1(new $.anon(this));},
 is$_BufferingSendPort: true,
 is$SendPort: true
};

$$._ReceivePortImpl = {"":
 ["_id?", "_callback?"],
 "super": "Object",
 _callback$2: function(arg0, arg1) { return this._callback.call$2(arg0, arg1); },
 receive$1: function(onMessage){this._callback=onMessage;},
 close$0: function(){this._callback=null;$._globalState().get$currentContext().unregister$1(this._id);},
 toSendPort$0: function(){return $._NativeJsSendPort$(this,$._globalState().get$currentContext().get$id());},
 _ReceivePortImpl$0: function(){$._globalState().get$currentContext().register$2(this._id,this);}
};

$$._PendingSendPortFinder = {"":
 ["ports?", "_visited"],
 "super": "_MessageTraverser",
 visitPrimitive$1: function(x){},
 visitList$1: function(list){var t1=this._visited;if(!($.index(t1,list)==null))return;$.indexSet(t1,list,true);$.forEach(list,new $._PendingSendPortFinder_visitList_anon(this));},
 visitMap$1: function(map){var t1=this._visited;if(!($.index(t1,map)==null))return;$.indexSet(t1,map,true);$.forEach(map.getValues$0(),new $._PendingSendPortFinder_visitMap_anon(this));},
 visitSendPort$1: function(port){if(!!port.is$_BufferingSendPort&&port._port==null)this.ports.push(port.get$_futurePort());},
 _PendingSendPortFinder$0: function(){this._visited=$._JsVisitedMap$();}
};

$$._JsSerializer = {"":
 ["_nextFreeRefId", "_visited"],
 "super": "_Serializer",
 visitSendPort$1: function(x){if(typeof x==='object'&&x!==null&&!!x.is$_NativeJsSendPort)return this.visitNativeJsSendPort$1(x);if(typeof x==='object'&&x!==null&&!!x.is$_WorkerSendPort)return this.visitWorkerSendPort$1(x);if(typeof x==='object'&&x!==null&&!!x.is$_BufferingSendPort)return this.visitBufferingSendPort$1(x);throw $.$$throw('Illegal underlying port '+$.S(x));},
 visitNativeJsSendPort$1: function(port){return ['sendport',$._globalState().get$currentManagerId(),port._isolateId,port._receivePort.get$_id()];},
 visitWorkerSendPort$1: function(port){return ['sendport',port._workerId,port._isolateId,port._receivePortId];},
 visitBufferingSendPort$1: function(port){var t1=port._port;if(!(t1==null))return this.visitSendPort$1(t1);else throw $.$$throw('internal error: must call _waitForPendingPorts to ensure all ports are resolved at this point.');},
 _JsSerializer$0: function(){this._visited=$._JsVisitedMap$();}
};

$$._JsCopier = {"":
 ["_visited"],
 "super": "_Copier",
 visitSendPort$1: function(x){if(typeof x==='object'&&x!==null&&!!x.is$_NativeJsSendPort)return this.visitNativeJsSendPort$1(x);if(typeof x==='object'&&x!==null&&!!x.is$_WorkerSendPort)return this.visitWorkerSendPort$1(x);if(typeof x==='object'&&x!==null&&!!x.is$_BufferingSendPort)return this.visitBufferingSendPort$1(x);throw $.$$throw('Illegal underlying port '+$.S(this.get$p()));},
 visitNativeJsSendPort$1: function(port){return $._NativeJsSendPort$(port._receivePort,port._isolateId);},
 visitWorkerSendPort$1: function(port){return $._WorkerSendPort$(port._workerId,port._isolateId,port._receivePortId);},
 visitBufferingSendPort$1: function(port){var t1=port._port;if(!(t1==null))return this.visitSendPort$1(t1);else throw $.$$throw('internal error: must call _waitForPendingPorts to ensure all ports are resolved at this point.');},
 _JsCopier$0: function(){this._visited=$._JsVisitedMap$();}
};

$$._JsDeserializer = {"":
 ["_deserialized"],
 "super": "_Deserializer",
 deserializeSendPort$1: function(x){var managerId=$.index(x,1);var isolateId=$.index(x,2);var receivePortId=$.index(x,3);if($.eqB(managerId,$._globalState().get$currentManagerId())){var isolate=$.index($._globalState().get$isolates(),isolateId);if(isolate==null)return;return $._NativeJsSendPort$(isolate.lookup$1(receivePortId),isolateId);}else return $._WorkerSendPort$(managerId,isolateId,receivePortId);}
};

$$._JsVisitedMap = {"":
 ["tagged"],
 "super": "Object",
 operator$index$1: function(object){return this._getAttachedInfo$1(object);},
 operator$indexSet$2: function(object,info){$.add$1(this.tagged,object);this._setAttachedInfo$2(object,info);},
 reset$0: function(){this.tagged=$.ListImplementation_List(null);},
 cleanup$0: function(){var length$=$.get$length(this.tagged);if(typeof length$!=='number')return this.cleanup$0$bailout(1,length$);var i=0;for(;i<length$;++i)this._clearAttachedInfo$1($.index(this.tagged,i));this.tagged=null;},
 cleanup$0$bailout: function(state,length$){var i=0;for(;$.ltB(i,length$);++i)this._clearAttachedInfo$1($.index(this.tagged,i));this.tagged=null;},
 _clearAttachedInfo$1: function(o){o['__MessageTraverser__attached_info__'] = (void 0);},
 _setAttachedInfo$2: function(o,info){o['__MessageTraverser__attached_info__'] = info;},
 _getAttachedInfo$1: function(o){return o['__MessageTraverser__attached_info__'];}
};

$$._MessageTraverserVisitedMap = {"":
 [],
 "super": "Object",
 operator$index$1: function(object){return;},
 operator$indexSet$2: function(object,info){},
 reset$0: function(){},
 cleanup$0: function(){}
};

$$._MessageTraverser = {"":
 [],
 "super": "Object",
 traverse$1: function(x){if($._MessageTraverser_isPrimitive(x))return this.visitPrimitive$1(x);var t1=this._visited;t1.reset$0();var result=null;try{result=this._dispatch$1(x);}finally{t1.cleanup$0();}return result;},
 _dispatch$1: function(x){if($._MessageTraverser_isPrimitive(x))return this.visitPrimitive$1(x);if(typeof x==='object'&&x!==null&&(x.constructor===Array||x.is$List()))return this.visitList$1(x);if(typeof x==='object'&&x!==null&&x.is$Map())return this.visitMap$1(x);if(typeof x==='object'&&x!==null&&!!x.is$SendPort)return this.visitSendPort$1(x);if(typeof x==='object'&&x!==null&&!!x.is$SendPortSync)return this.visitSendPortSync$1(x);return this.visitObject$1(x);},
 visitObject$1: function(x){throw $.$$throw('Message serialization: Illegal value '+$.S(x)+' passed');}
};

$$._Copier = {"":
 [],
 "super": "_MessageTraverser",
 visitPrimitive$1: function(x){return x;},
 visitList$1: function(list){if(typeof list!=='object'||list===null||list.constructor!==Array&&!list.is$JavaScriptIndexingBehavior())return this.visitList$1$bailout(1,list);var t1=this._visited;var copy=t1.operator$index$1(list);if(!(copy==null))return copy;var len=list.length;copy=$.ListImplementation_List(len);t1.operator$indexSet$2(list,copy);for(var i=0;i<len;++i){if(i<0||i>=list.length)throw $.ioore(i);t1=this._dispatch$1(list[i]);if(i<0||i>=copy.length)throw $.ioore(i);copy[i]=t1;}return copy;},
 visitList$1$bailout: function(state,list){var t1=this._visited;var copy=$.index(t1,list);if(!(copy==null))return copy;var len=$.get$length(list);copy=$.ListImplementation_List(len);$.indexSet(t1,list,copy);for(var i=0;$.ltB(i,len);++i){t1=this._dispatch$1($.index(list,i));if(i<0||i>=copy.length)throw $.ioore(i);copy[i]=t1;}return copy;},
 visitMap$1: function(map){var t1={};var t2=this._visited;t1.copy_10=$.index(t2,map);var t3=t1.copy_10;if(!(t3==null))return t3;t1.copy_10=$.HashMapImplementation$();$.indexSet(t2,map,t1.copy_10);map.forEach$1(new $._Copier_visitMap_anon(this,t1));return t1.copy_10;}
};

$$._Serializer = {"":
 [],
 "super": "_MessageTraverser",
 visitPrimitive$1: function(x){return x;},
 visitList$1: function(list){var t1=this._visited;var copyId=$.index(t1,list);if(!(copyId==null))return ['ref',copyId];var id=this._nextFreeRefId;this._nextFreeRefId=id+1;$.indexSet(t1,list,id);return ['list',id,this._serializeList$1(list)];},
 visitMap$1: function(map){var t1=this._visited;var copyId=$.index(t1,map);if(!(copyId==null))return ['ref',copyId];var id=this._nextFreeRefId;this._nextFreeRefId=id+1;$.indexSet(t1,map,id);return ['map',id,this._serializeList$1(map.getKeys$0()),this._serializeList$1(map.getValues$0())];},
 _serializeList$1: function(list){if(typeof list!=='string'&&(typeof list!=='object'||list===null||list.constructor!==Array&&!list.is$JavaScriptIndexingBehavior()))return this._serializeList$1$bailout(1,list);var len=list.length;var result=$.ListImplementation_List(len);for(var i=0;i<len;++i){if(i<0||i>=list.length)throw $.ioore(i);var t1=this._dispatch$1(list[i]);if(i<0||i>=result.length)throw $.ioore(i);result[i]=t1;}return result;},
 _serializeList$1$bailout: function(state,list){var len=$.get$length(list);var result=$.ListImplementation_List(len);for(var i=0;$.ltB(i,len);++i){var t1=this._dispatch$1($.index(list,i));if(i<0||i>=result.length)throw $.ioore(i);result[i]=t1;}return result;}
};

$$._Deserializer = {"":
 [],
 "super": "Object",
 deserialize$1: function(x){if($._Deserializer_isPrimitive(x))return x;this._deserialized=$.HashMapImplementation$();return this._deserializeHelper$1(x);},
 _deserializeHelper$1: function(x){if($._Deserializer_isPrimitive(x))return x;switch($.index(x,0)){case 'ref':return this._deserializeRef$1(x);case 'list':return this._deserializeList$1(x);case 'map':return this._deserializeMap$1(x);case 'sendport':return this.deserializeSendPort$1(x);default:return this.deserializeObject$1(x);}},
 _deserializeRef$1: function(x){var id=$.index(x,1);return $.index(this._deserialized,id);},
 _deserializeList$1: function(x){var id=$.index(x,1);var dartList=$.index(x,2);if(typeof dartList!=='object'||dartList===null||(dartList.constructor!==Array||!!dartList.immutable$list)&&!dartList.is$JavaScriptIndexingBehavior())return this._deserializeList$1$bailout(1,dartList,id);$.indexSet(this._deserialized,id,dartList);var len=dartList.length;for(var i=0;i<len;++i){if(i<0||i>=dartList.length)throw $.ioore(i);var t1=this._deserializeHelper$1(dartList[i]);if(i<0||i>=dartList.length)throw $.ioore(i);dartList[i]=t1;}return dartList;},
 _deserializeList$1$bailout: function(state,dartList,id){$.indexSet(this._deserialized,id,dartList);var len=$.get$length(dartList);for(var i=0;$.ltB(i,len);++i)$.indexSet(dartList,i,this._deserializeHelper$1($.index(dartList,i)));return dartList;},
 _deserializeMap$1: function(x){var result=$.HashMapImplementation$();var id=$.index(x,1);$.indexSet(this._deserialized,id,result);var keys=$.index(x,2);if(typeof keys!=='string'&&(typeof keys!=='object'||keys===null||keys.constructor!==Array&&!keys.is$JavaScriptIndexingBehavior()))return this._deserializeMap$1$bailout(1,x,result,keys);var values=$.index(x,3);if(typeof values!=='string'&&(typeof values!=='object'||values===null||values.constructor!==Array&&!values.is$JavaScriptIndexingBehavior()))return this._deserializeMap$1$bailout(2,values,result,keys);var len=keys.length;for(var i=0;i<len;++i){if(i<0||i>=keys.length)throw $.ioore(i);var key=this._deserializeHelper$1(keys[i]);if(i<0||i>=values.length)throw $.ioore(i);result.operator$indexSet$2(key,this._deserializeHelper$1(values[i]));}return result;},
 _deserializeMap$1$bailout: function(state,env0,env1,env2){switch(state){case 1:var x=env0;result=env1;keys=env2;break;case 2:values=env0;result=env1;keys=env2;break;}switch(state){case 0:var result=$.HashMapImplementation$();var id=$.index(x,1);$.indexSet(this._deserialized,id,result);var keys=$.index(x,2);case 1:state=0;var values=$.index(x,3);case 2:state=0;var len=$.get$length(keys);for(var i=0;$.ltB(i,len);++i)result.operator$indexSet$2(this._deserializeHelper$1($.index(keys,i)),this._deserializeHelper$1($.index(values,i)));return result;}},
 deserializeObject$1: function(x){throw $.$$throw('Unexpected serialized object');}
};

$$._Timer = {"":
 ["_once", "_handle"],
 "super": "Object",
 cancel$0: function(){var t1=this._once===true;var t2=this._handle;if(t1)$._window().clearTimeout$1(t2);else $._window().clearInterval$1(t2);},
 _Timer$repeating$2: function(milliSeconds,callback){this._handle=$._window().setInterval$2(new $.anon7(this,callback),milliSeconds);},
 _Timer$2: function(milliSeconds,callback){this._handle=$._window().setTimeout$2(new $.anon6(this,callback),milliSeconds);}
};

$$.Uri = {"":
 ["scheme", "userInfo", "domain", "port", "path", "query", "fragment"],
 "super": "Object",
 query$1: function(arg0) { return this.query.call$1(arg0); },
 isAbsolute$0: function(){if(''===this.scheme)return false;if(!(''===this.fragment))return false;return true;},
 hasAuthority$0: function(){return !$.eqB(this.userInfo,'')||!$.eqB(this.domain,'')||!$.eqB(this.port,0);},
 toString$0: function(){var sb=$.StringBufferImpl$('');var t1=this.scheme;$.Uri__addIfNonEmpty(sb,t1,t1,':');if(this.hasAuthority$0()===true||$.eqB(t1,'file')){sb.add$1('//');t1=this.userInfo;$.Uri__addIfNonEmpty(sb,t1,t1,'@');t1=this.domain;sb.add$1(t1==null?'null':t1);t1=this.port;if(!$.eqB(t1,0)){sb.add$1(':');sb.add$1($.toString(t1));}}t1=this.path;sb.add$1(t1==null?'null':t1);t1=this.query;$.Uri__addIfNonEmpty(sb,t1,'?',t1);t1=this.fragment;$.Uri__addIfNonEmpty(sb,t1,'#',t1);return sb.toString$0();}
};

$$.DisposableImpl = {"":
 [],
 "super": "Object"
};

$$.GlobalId = {"":
 ["id?", "_hashCode"],
 "super": "Object",
 compareTo$1: function(other){return $.compareTo(this.id,other.get$id());},
 hashCode$0: function(){return this._hashCode;},
 operator$eq$1: function(other){return !(other==null)&&$.eqB(other.get$id(),this.id);}
};

$$.Tuple = {"":
 ["Item1?", "Item2?"],
 "super": "Object",
 operator$eq$1: function(other){return !(other==null)&&$.eqB(this.Item1,other.get$Item1())&&$.eqB(this.Item2,other.get$Item2());},
 toString$0: function(){return 'Tuple: Item1: '+$.S(this.Item1)+', Item2: '+$.S(this.Item2);}
};

$$.Tuple3 = {"":
 ["Item3?", "Item1", "Item2"],
 "super": "Tuple",
 operator$eq$1: function(other){return !(other==null)&&$.eqB(this.Item1,other.get$Item1())&&$.eqB(this.Item2,other.get$Item2())&&$.eqB(this.Item3,other.get$Item3());},
 toString$0: function(){return 'Tuple3: Item1: '+$.S(this.Item1)+', Item2: '+$.S(this.Item2)+', Item3: '+$.S(this.Item3);}
};

$$.NullArgumentException = {"":
 ["theArg", "_arg"],
 "super": "IllegalArgumentException",
 toString$0: function(){return 'Null argument(s): '+$.S(this.theArg);}
};

$$.InvalidOperationException = {"":
 ["message?"],
 "super": "Object",
 is$Exception: true
};

$$.DetailedIllegalArgumentException = {"":
 ["argument", "message?", "_arg"],
 "super": "IllegalArgumentException",
 toString$0: function(){var t1=this.message;var t2=t1==null||$.eqB($.get$length(t1),0);var t3=this.argument;if(t2)return 'Illegal argument: '+$.S(t3);else return 'Illegal argument: '+$.S(t3)+' -- '+$.S(t1);}
};

$$.Enumerable = {"":
 [],
 "super": "Object",
 join$1: function(separator){var sb=$.StringBufferImpl$('');for(var t1=$.iterator(this);t1.hasNext$0()===true;){var t2=t1.next$0();if($.gtB($.get$length(sb),0))sb.add$1(separator);sb.add$1(t2);}return sb.toString$0();},
 join$0: function() {
  return this.join$1(', ')
},
 select$1: function(f){$.requireArgumentNotNull(f,'f');return $._FuncEnumerable$(this,new $.Enumerable_select_anon(this,f));},
 where$1: function(f){$.requireArgumentNotNull(f,'f');return $._FuncEnumerable$(this,new $.Enumerable_where_anon(this,f));},
 selectMany$1: function(f){$.requireArgumentNotNull(f,'f');return $._FuncEnumerable$(this,new $.Enumerable_selectMany_anon(f));},
 first$1: function(f){if(f==null)f=new $.Enumerable_first_anon();var iter=$._WhereIterator$(this.iterator$0(),f,$.getRuntimeTypeInfo(this).T);if(iter.hasNext$0()!==true)throw $.$$throw($.CTC21);return iter.next$0();},
 first$0: function() {
  return this.first$1(null)
},
 get$first: function() { return new $.BoundClosure1(this, 'first$1'); },
 single$1: function(f){if(f==null)f=new $.Enumerable_single_anon();var iter=$._WhereIterator$(this.iterator$0(),f,$.getRuntimeTypeInfo(this).T);if(iter.hasNext$0()!==true)throw $.$$throw($.CTC21);var value=iter.next$0();if(iter.hasNext$0()===true)throw $.$$throw($.CTC31);return value;},
 group$1: function(keyFunc){return $.Grouping_Grouping(this,keyFunc);},
 toReadOnlyCollection$0: function(){return $.ReadOnlyCollection$(this,$.getRuntimeTypeInfo(this).T);},
 forEach$1: function(f){for(var t1=$.iterator(this);t1.hasNext$0()===true;)f.call$1(t1.next$0());},
 forEachWithIndex$1: function(f){for(var t1=$.iterator(this),i=0;t1.hasNext$0()===true;){var t2=t1.next$0();var i0=i+1;f.call$2(t2,i);i=i0;}},
 toList$0: function(){return $.ListImplementation_List$from(this,$.getRuntimeTypeInfo(this).T);},
 toHashMap$2: function(valueFunc,keyFunc){var t1={};if(keyFunc==null)keyFunc=new $.Enumerable_toHashMap_anon();t1.duplicate_1=null;var populate=new $.Enumerable_toHashMap_anon0(t1,valueFunc,null);var map=$.HashMapImplementation$();for(var t2=$.iterator(this),e=null;t2.hasNext$0()===true;){e=t2.next$0();var k=keyFunc.call$1(e);t1.duplicate_1=true;map.putIfAbsent$2(k,populate);if(t1.duplicate_1===true)throw $.$$throw($.UnsupportedOperationException$('The key \''+$.S(k)+'\' is duplicated'));}return map;},
 toHashMap$1: function(valueFunc) {
  return this.toHashMap$2(valueFunc,null)
},
 toString$0: function(){return '['+$.S(this.join$0())+']';},
 is$Enumerable: true
};

$$._SimpleEnumerable = {"":
 ["_source"],
 "super": "Enumerable",
 iterator$0: function(){return $.iterator(this._source);}
};

$$._FuncEnumerable = {"":
 ["_source", "_func"],
 "super": "Enumerable",
 _func$1: function(arg0) { return this._func.call$1(arg0); },
 iterator$0: function(){return this._func$1($.iterator(this._source));}
};

$$._SelectIterator = {"":
 ["_source", "_func"],
 "super": "Object",
 _func$1: function(arg0) { return this._func.call$1(arg0); },
 hasNext$0: function(){return this._source.hasNext$0();},
 next$0: function(){return this._func$1(this._source.next$0());}
};

$$._WhereIterator = {"":
 ["_source", "_func", "_lib1_next=", "_current"],
 "super": "Object",
 _func$1: function(arg0) { return this._func.call$1(arg0); },
 hasNext$0: function(){if(this._lib1_next==null){this._lib1_next=false;for(var t1=this._source;t1.hasNext$0()===true;){this._current=t1.next$0();if(this._func$1(this._current)===true){this._lib1_next=true;break;}}}return this._lib1_next;},
 next$0: function(){if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);this._lib1_next=null;return this._current;}
};

$$._SelectManyIterator = {"":
 ["_sourceIterator", "_func", "_outputIterator"],
 "super": "Object",
 _func$1: function(arg0) { return this._func.call$1(arg0); },
 hasNext$0: function(){var t1=this._outputIterator;if(!(t1==null))if(t1.hasNext$0()===true)return true;else this._outputIterator=null;t1=this._sourceIterator;if(t1.hasNext$0()===true){this._outputIterator=$.iterator(this._func$1(t1.next$0()));return this._outputIterator.hasNext$0();}return false;},
 next$0: function(){if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);return this._outputIterator.next$0();}
};

$$.IndexIterator = {"":
 ["_indexer", "_lib1_length", "_lib1_pos"],
 "super": "Object",
 hasNext$0: function(){var t1=this._lib1_length;if(typeof t1!=='number')return this.hasNext$0$bailout(1,t1,0);var t3=this._lib1_pos;if(typeof t3!=='number')return this.hasNext$0$bailout(2,t1,t3);return t1>t3;},
 hasNext$0$bailout: function(state,env0,env1){switch(state){case 1:t1=env0;break;case 2:t1=env0;t3=env1;break;}switch(state){case 0:var t1=this._lib1_length;case 1:state=0;var t3=this._lib1_pos;case 2:state=0;return $.gt(t1,t3);}},
 next$0: function(){if(this.hasNext$0()!==true)throw $.$$throw($.CTC11);var t1=this._lib1_pos;if(typeof t1!=='number')return this.next$0$bailout(1,t1);this._lib1_pos=t1+1;return this._indexer$1(t1);},
 next$0$bailout: function(state,t1){this._lib1_pos=$.add(t1,1);return this._indexer$1(t1);},
 _indexer$1: function(arg0) { return this._indexer.call$1(arg0); },
 IndexIterator$2: function(length$,indexer){$.requireArgumentNotNull(this._indexer,'_indexer');}
};

$$.ListBase = {"":
 [],
 "super": "Enumerable",
 iterator$0: function(){return $.IndexIterator$($.get$length(this),new $.ListBase_iterator_anon(this),$.getRuntimeTypeInfo(this).T);},
 forEach$1: function(f){for(var i=0;$.ltB(i,$.get$length(this));++i)f.call$1(this.operator$index$1(i));},
 filter$1: function(f){var list=$.ListImplementation_List(null,$.getRuntimeTypeInfo(this).T);for(var i=0;$.ltB(i,$.get$length(this));++i){var e=this.operator$index$1(i);if(f.call$1(e)===true)list.push(e);}return list;},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 get$length: function(){throw $.$$throw($.CTC19);},
 operator$index$1: function(index){throw $.$$throw($.CTC19);},
 indexOf$2: function(element,start){for(var i=start;$.ltB(i,$.get$length(this));++i)if($.eqB(this.operator$index$1(i),element))return i;return -1;},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start!==(start|0))return this.lastIndexOf$2$bailout(1,element,start);for(var i=start,lastIndex=-1;$.ltB(i,$.get$length(this));++i)lastIndex=$.eqB(this.operator$index$1(i),element)?i:lastIndex;return lastIndex;},
 lastIndexOf$2$bailout: function(state,element,start){for(var i=start,lastIndex=-1;$.ltB(i,$.get$length(this));i=$.add(i,1))lastIndex=$.eqB(this.operator$index$1(i),element)?i:lastIndex;return lastIndex;},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,0)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 getRange$2: function(start,itemCount){if(typeof start!=='number')return this.getRange$2$bailout(1,start,itemCount);$.requireArgument($.ge(itemCount,0),'count',null);if(typeof itemCount!=='number')throw $.iae(itemCount);var lastIndex=start+itemCount-1;if(itemCount>0)if(start<0)throw $.$$throw($.IndexOutOfRangeException$(start));else if($.geB(lastIndex,$.get$length(this)))throw $.$$throw($.IndexOutOfRangeException$(lastIndex));var list=$.ListImplementation_List(null,$.getRuntimeTypeInfo(this).T);for(var i=start;i<=lastIndex;++i)list.push(this.operator$index$1(i));return list;},
 getRange$2$bailout: function(state,start,itemCount){$.requireArgument($.ge(itemCount,0),'count',null);var lastIndex=$.sub($.add(start,itemCount),1);if($.gtB(itemCount,0))if($.ltB(start,0))throw $.$$throw($.IndexOutOfRangeException$(start));else if($.geB(lastIndex,$.get$length(this)))throw $.$$throw($.IndexOutOfRangeException$(lastIndex));var list=$.ListImplementation_List(null,$.getRuntimeTypeInfo(this).T);for(var i=start;$.leB(i,lastIndex);i=$.add(i,1))list.push(this.operator$index$1(i));return list;},
 operator$indexSet$2: function(index,value){throw $.$$throw($.CTC18);},
 add$1: function(value){throw $.$$throw($.CTC18);},
 addLast$1: function(value){throw $.$$throw($.CTC18);},
 addAll$1: function(value){throw $.$$throw($.CTC18);},
 sort$1: function(comparer){throw $.$$throw($.CTC18);},
 clear$0: function(){throw $.$$throw($.CTC18);},
 removeLast$0: function(){throw $.$$throw($.CTC18);},
 removeRange$2: function(start,length$){throw $.$$throw($.CTC18);},
 insertRange$3: function(start,length$,initialValue){throw $.$$throw($.CTC18);},
 is$List: function() { return true; },
 is$Collection: function() { return true; }
};

$$.ReadOnlyCollection = {"":
 ["_items"],
 "super": "ListBase",
 get$length: function(){return $.get$length(this._items);},
 operator$index$1: function(index){var t1=this._items;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.operator$index$1$bailout(1,t1,index);if(index!==(index|0))throw $.iae(index);if(index<0||index>=t1.length)throw $.ioore(index);return t1[index];},
 operator$index$1$bailout: function(state,t1,index){return $.index(t1,index);}
};

$$.Grouping = {"":
 ["_lib1_values"],
 "super": "Object",
 containsKey$1: function(key){return this._lib1_values.containsKey$1(key);},
 operator$index$1: function(key){return $.index(this._lib1_values,key);},
 forEach$1: function(f){return $.forEach(this._lib1_values,f);},
 getKeys$0: function(){return this._lib1_values.getKeys$0();},
 get$length: function(){return $.get$length(this._lib1_values);},
 get$isEmpty: function(){return $.isEmpty(this._lib1_values);},
 isEmpty$0: function() { return this.get$isEmpty().call$0(); },
 toString$0: function(){return $.toString(this._lib1_values);}
};

$$.NoneHashMap = {"":
 ["_lib1_values"],
 "super": "Object",
 putIfAbsent$2: function(key,ifAbsent){for(var t1=this._lib1_values,t2=$.iterator(t1);t2.hasNext$0()===true;){var t3=t2.next$0();if($.eqB(t3.get$Item1(),key))return t3.get$Item2();}var t=$.Tuple$(key,ifAbsent.call$0());t1.push(t);return t.Item2;},
 getKeys$0: function(){return $.$$(this._lib1_values).select$1(new $.NoneHashMap_getKeys_anon()).toList$0();},
 getValues$0: function(){return $.$$(this._lib1_values).select$1(new $.NoneHashMap_getValues_anon()).toList$0();},
 get$length: function(){return this._lib1_values.length;},
 forEach$1: function(f){for(var t1=$.iterator(this._lib1_values);t1.hasNext$0()===true;){var t2=t1.next$0();f.call$2(t2.get$Item1(),t2.get$Item2());}},
 containsKey$1: function(key){for(var t1=$.iterator(this._lib1_values);t1.hasNext$0()===true;)if($.eqB(t1.next$0().get$Item1(),key))return true;return false;},
 operator$index$1: function(key){for(var t1=$.iterator(this._lib1_values);t1.hasNext$0()===true;){var t2=t1.next$0();if($.eqB(t2.get$Item1(),key))return t2.get$Item2();}return;},
 operator$indexSet$2: function(key,value){var newT=$.Tuple$(key,value,$.getRuntimeTypeInfo(this).K,$.getRuntimeTypeInfo(this).V);for(var t1=this._lib1_values,i=0;i<t1.length;++i){if(i<0||i>=t1.length)throw $.ioore(i);if($.eqB(t1[i].get$Item1(),key)){if(i<0||i>=t1.length)throw $.ioore(i);t1[i]=newT;return;}}t1.push(newT);},
 remove$1: function(key){for(var t1=this._lib1_values,i=0;i<t1.length;++i){if(i<0||i>=t1.length)throw $.ioore(i);if($.eqB(t1[i].get$Item1(),key)){if(i<0||i>=t1.length)throw $.ioore(i);var t=t1[i];$.removeRange(t1,i,1);return t.get$Item2();}}return;},
 clear$0: function(){throw $.$$throw('not impled');},
 isEmpty$0: function(){throw $.$$throw('not impled');},
 toString$0: function(){return $.Maps_mapToString(this);},
 is$Map: function() { return true; }
};

$$.EventHandle = {"":
 ["_handlers", "_disposed"],
 "super": "DisposableImpl",
 fireEvent$1: function(args){var t1=this._handlers;if(!(t1==null))$.forEach(t1,new $.EventHandle_fireEvent_anon(args));},
 add$1: function(handler){var id=$.GlobalId_GlobalId();if(this._handlers==null)this._handlers=$.HashMapImplementation$('GlobalId','Action1<T>');$.indexSet(this._handlers,id,handler);return id;},
 remove$1: function(id){var t1=this._handlers;if(!(t1==null))return !(t1.remove$1(id)==null);else return false;}
};

$$.EventArgs = {"":
 [],
 "super": "Object"
};

$$.CancelableEventArgs = {"":
 ["_canceled"],
 "super": "EventArgs",
 get$isCanceled: function(){return this._canceled;},
 cancel$0: function(){this._canceled=true;}
};

$$.Size = {"":
 ["width?", "height?"],
 "super": "Object",
 operator$eq$1: function(other){return !(other==null)&&$.eqB(this.width,other.get$width())&&$.eqB(this.height,other.get$height());},
 get$area: function(){return $.mul(this.width,this.height);},
 get$aspectRatio: function(){return $.div(this.width,this.height);},
 isEmpty$0: function(){return $.eq(this.get$area(),0);},
 get$isValid: function(){var t1=this.width;if($.isValidNumber(t1)){var t2=this.height;t1=$.isValidNumber(t2)&&$.geB(t1,0)&&$.geB(t2,0);}else t1=false;return t1;},
 scale$1: function(magnitude){return $.Size$($.mul(this.width,magnitude),$.mul(this.height,magnitude));},
 operator$mul$1: function(magnitude){return this.scale$1(magnitude);},
 toString$0: function(){return '('+$.S(this.width)+' x '+$.S(this.height)+')';}
};

$$.Coordinate = {"":
 ["x?", "y?"],
 "super": "Object",
 getDistance$1: function(other){return $.get$length(this.operator$sub$1(other));},
 get$isValid: function(){return $.isValidNumber(this.x)&&$.isValidNumber(this.y);},
 operator$sub$1: function(other){return $.Coordinate_difference(this,other);},
 operator$add$1: function(other){return $.Coordinate$($.add(this.x,other.get$x()),$.add(this.y,other.get$y()));},
 operator$eq$1: function(other){return !(other==null)&&$.eqB(this.x,other.get$x())&&$.eqB(this.y,other.get$y());},
 toString$0: function(){return '{x:'+$.S(this.x)+', y:'+$.S(this.y)+'}';}
};

$$.Vector = {"":
 ["x", "y"],
 "super": "Coordinate",
 get$length: function(){var t1=this.x;t1=$.mul(t1,t1);var t2=this.y;return $.sqrt($.add(t1,$.mul(t2,t2)));},
 operator$add$1: function(other){return $.Vector$($.add(this.x,other.get$x()),$.add(this.y,other.get$y()));},
 operator$mul$1: function(magnitude){return this.scale$1(magnitude);},
 scale$1: function(magnitude){return $.Vector$($.mul(this.x,magnitude),$.mul(this.y,magnitude));}
};

$$.Rect = {"":
 ["left?", "top?", "width?", "height?"],
 "super": "Object",
 get$topLeft: function(){return $.Coordinate$(this.left,this.top);},
 get$size: function(){return $.Size$(this.width,this.height);},
 get$isValid: function(){return this.get$topLeft().get$isValid()===true&&this.get$size().get$isValid()===true;},
 get$right: function(){return $.add(this.left,this.width);},
 get$bottom: function(){return $.add(this.top,this.height);},
 contains$1: function(point){var t1=point.get$x();var t2=this.left;if($.geB(t1,t2))if($.leB(point.get$x(),$.add(t2,this.width))){t1=point.get$y();t2=this.top;t1=$.geB(t1,t2)&&$.leB(point.get$y(),$.add(t2,this.height));}else t1=false;else t1=false;return t1;},
 constrain$1: function(value){$.requireArgumentNotNull(value,'value');$.requireArgument(value.get$isValid(),'value',null);return $.Coordinate$($.min(this.get$right(),$.max(this.left,value.get$x())),$.min(this.get$bottom(),$.max(this.top,value.get$y())));},
 operator$eq$1: function(other){return !(other==null)&&$.eqB(other.get$left(),this.left)&&$.eqB(other.get$top(),this.top)&&$.eqB(other.get$width(),this.width)&&$.eqB(other.get$height(),this.height);},
 toString$0: function(){return 'Location: '+$.S(this.get$topLeft())+', Size: '+$.S(this.get$size());},
 hashCode$0: function(){return $.Util_getHashCode([this.left,this.top,this.width,this.height]);}
};

$$.AffineTransform = {"":
 ["_m00?", "_m10?", "_m01?", "_m11?", "_m02?", "_m12?"],
 "super": "Object",
 get$scaleX: function(){return this._m00;},
 get$scaleY: function(){return this._m11;},
 get$translateX: function(){return this._m02;},
 get$translateY: function(){return this._m12;},
 get$shearX: function(){return this._m01;},
 get$shearY: function(){return this._m10;},
 get$determinant: function(){return $.sub($.mul(this._m00,this._m11),$.mul(this._m01,this._m10));},
 concatenate$1: function(tx){var m0=this._m00;if(typeof m0!=='number')return this.concatenate$1$bailout(1,tx,m0,0,0,0);var m1=this._m01;if(typeof m1!=='number')return this.concatenate$1$bailout(2,tx,m0,m1,0,0);var t3=tx.get$_m00();if(typeof t3!=='number')return this.concatenate$1$bailout(3,tx,t3,m0,m1,0);t3*=m0;var t5=tx.get$_m10();if(typeof t5!=='number')return this.concatenate$1$bailout(4,tx,t5,m0,m1,t3);this._m00=t3+t5*m1;var t7=tx.get$_m01();if(typeof t7!=='number')return this.concatenate$1$bailout(5,tx,m0,m1,t7,0);t7*=m0;var t9=tx.get$_m11();if(typeof t9!=='number')return this.concatenate$1$bailout(6,tx,t7,t9,m0,m1);this._m01=t7+t9*m1;var t11=this._m02;if(typeof t11!=='number')return this.concatenate$1$bailout(7,tx,t11,m0,m1,0);var t13=tx.get$_m02();if(typeof t13!=='number')return this.concatenate$1$bailout(8,tx,t13,t11,m0,m1);t13*=m0;var t15=tx.get$_m12();if(typeof t15!=='number')return this.concatenate$1$bailout(9,tx,t11,t13,t15,m1);this._m02=t11+(t13+t15*m1);m0=this._m10;if(typeof m0!=='number')return this.concatenate$1$bailout(10,tx,m0,0,0,0);var m10=this._m11;if(typeof m10!=='number')return this.concatenate$1$bailout(11,tx,m0,m10,0,0);var t19=tx.get$_m00();if(typeof t19!=='number')return this.concatenate$1$bailout(12,tx,m0,m10,t19,0);t19*=m0;var t21=tx.get$_m10();if(typeof t21!=='number')return this.concatenate$1$bailout(13,tx,t21,m0,m10,t19);this._m10=t19+t21*m10;var t23=tx.get$_m01();if(typeof t23!=='number')return this.concatenate$1$bailout(14,tx,m0,m10,t23,0);t23*=m0;var t25=tx.get$_m11();if(typeof t25!=='number')return this.concatenate$1$bailout(15,tx,t23,t25,m0,m10);this._m11=t23+t25*m10;var t27=this._m12;if(typeof t27!=='number')return this.concatenate$1$bailout(16,tx,m0,m10,t27,0);var t29=tx.get$_m02();if(typeof t29!=='number')return this.concatenate$1$bailout(17,tx,t29,m0,m10,t27);t29*=m0;var t31=tx.get$_m12();if(typeof t31!=='number')return this.concatenate$1$bailout(18,t29,t31,m10,t27,0);this._m12=t27+(t29+t31*m10);return this;},
 concatenate$1$bailout: function(state,env0,env1,env2,env3,env4){switch(state){case 1:var tx=env0;m0=env1;break;case 2:tx=env0;m0=env1;m1=env2;break;case 3:tx=env0;t3=env1;m0=env2;m1=env3;break;case 4:tx=env0;t5=env1;m0=env2;m1=env3;t3=env4;break;case 5:tx=env0;m0=env1;m1=env2;t7=env3;break;case 6:tx=env0;t7=env1;t9=env2;m0=env3;m1=env4;break;case 7:tx=env0;t11=env1;m0=env2;m1=env3;break;case 8:tx=env0;t13=env1;t11=env2;m0=env3;m1=env4;break;case 9:tx=env0;t11=env1;t13=env2;t15=env3;m1=env4;break;case 10:tx=env0;m0=env1;break;case 11:tx=env0;m0=env1;m10=env2;break;case 12:tx=env0;m0=env1;m10=env2;t19=env3;break;case 13:tx=env0;t21=env1;m0=env2;m10=env3;t19=env4;break;case 14:tx=env0;m0=env1;m10=env2;t23=env3;break;case 15:tx=env0;t23=env1;t25=env2;m0=env3;m10=env4;break;case 16:tx=env0;m0=env1;m10=env2;t27=env3;break;case 17:tx=env0;t29=env1;m0=env2;m10=env3;t27=env4;break;case 18:t29=env0;t31=env1;m10=env2;t27=env3;break;}switch(state){case 0:var m0=this._m00;case 1:state=0;var m1=this._m01;case 2:state=0;var t3=tx.get$_m00();case 3:state=0;t3=$.mul(t3,m0);var t5=tx.get$_m10();case 4:state=0;this._m00=$.add(t3,$.mul(t5,m1));var t7=tx.get$_m01();case 5:state=0;t7=$.mul(t7,m0);var t9=tx.get$_m11();case 6:state=0;this._m01=$.add(t7,$.mul(t9,m1));var t11=this._m02;case 7:state=0;var t13=tx.get$_m02();case 8:state=0;t13=$.mul(t13,m0);var t15=tx.get$_m12();case 9:state=0;this._m02=$.add(t11,$.add(t13,$.mul(t15,m1)));m0=this._m10;case 10:state=0;var m10=this._m11;case 11:state=0;var t19=tx.get$_m00();case 12:state=0;t19=$.mul(t19,m0);var t21=tx.get$_m10();case 13:state=0;this._m10=$.add(t19,$.mul(t21,m10));var t23=tx.get$_m01();case 14:state=0;t23=$.mul(t23,m0);var t25=tx.get$_m11();case 15:state=0;this._m11=$.add(t23,$.mul(t25,m10));var t27=this._m12;case 16:state=0;var t29=tx.get$_m02();case 17:state=0;t29=$.mul(t29,m0);var t31=tx.get$_m12();case 18:state=0;this._m12=$.add(t27,$.add(t29,$.mul(t31,m10)));return this;}},
 get$concatenate: function() { return new $.BoundClosure0(this, 'concatenate$1'); },
 translate$2: function(dx,dy){this._m02=$.add(this._m02,$.add($.mul(dx,this._m00),$.mul(dy,this._m01)));this._m12=$.add(this._m12,$.add($.mul(dx,this._m10),$.mul(dy,this._m11)));return this;},
 setToScale$2: function(sx,sy){return this.setTransform$6(sx,0,0,sy,0,0);},
 setFromTransfrom$1: function(tx){$.requireArgumentNotNull(tx,'tx');return this.setTransform$6(tx.get$_m00(),tx.get$_m10(),tx.get$_m01(),tx.get$_m11(),tx.get$_m02(),tx.get$_m12());},
 setTransform$6: function(m00,m10,m01,m11,m02,m12){this._m00=m00;this._m10=m10;this._m01=m01;this._m11=m11;this._m02=m02;this._m12=m12;return this;},
 transformCoordinate$1: function(point){return $.Coordinate$($.add($.add($.mul(point.get$x(),this._m00),$.mul(point.get$y(),this._m01)),this._m02),$.add($.add($.mul(point.get$x(),this._m10),$.mul(point.get$y(),this._m11)),this._m12));},
 createInverse$0: function(){var det=this.get$determinant();return $.AffineTransform$($.div(this._m11,det),$.div($.neg(this._m10),det),$.div($.neg(this._m01),det),$.div(this._m00,det),$.div($.sub($.mul(this._m01,this._m12),$.mul(this._m11,this._m02)),det),$.div($.sub($.mul(this._m10,this._m02),$.mul(this._m00,this._m12)),det));},
 operator$eq$1: function(other){return !(other==null)&&$.eqB(this._m00,other.get$_m00())&&$.eqB(this._m01,other.get$_m01())&&$.eqB(this._m02,other.get$_m02())&&$.eqB(this._m10,other.get$_m10())&&$.eqB(this._m11,other.get$_m11())&&$.eqB(this._m12,other.get$_m12());},
 toString$0: function(){return $.Strings_join($.$$([this.get$translateX(),this.get$translateY(),this.get$scaleX(),this.get$scaleY(),this.get$shearX(),this.get$shearY()]).select$1(new $.AffineTransform_toString_anon()).toList$0(),', ');}
};

$$.RgbColor = {"":
 ["r?", "g?", "b?"],
 "super": "Object",
 toHex$0: function(){var buffer=$.StringBufferImpl$('#');$.forEach([this.r,this.g,this.b],new $.RgbColor_toHex_anon(buffer));return buffer.toString$0();},
 hashCode$0: function(){return $.Util_getHashCode([this.r,this.g,this.b]);},
 operator$eq$1: function(other){return !(other==null)&&$.eqB(other.get$r(),this.r)&&$.eqB(other.get$g(),this.g)&&$.eqB(other.get$b(),this.b);},
 toString$0: function(){return '{RgbColor: '+$.S(this.r)+', '+$.S(this.g)+', '+$.S(this.b)+'}';}
};

$$.HslColor = {"":
 ["h?", "s?", "l?"],
 "super": "Object",
 toRgb$0: function(){var t1=this.h;if(typeof t1!=='number')return this.toRgb$0$bailout(1,t1,0,0);var normH=t1/360;t1=this.s;if(typeof t1!=='number')return this.toRgb$0$bailout(2,normH,t1,0);if(t1===0){t1=this.l;if(typeof t1!=='number')return this.toRgb$0$bailout(3,t1,0,0);var b=t1*255;var g=b;var r=g;}else{var t2=this.l;if(typeof t2!=='number')return this.toRgb$0$bailout(4,t2,normH,t1);var temp2=t2<0.5?t2*(1+t1):t2+t1-t1*t2;var temp1=2*t2-temp2;r=255*$.HslColor__hueToRgb(temp1,temp2,normH+0.3333333333333333);g=255*$.HslColor__hueToRgb(temp1,temp2,normH);b=255*$.HslColor__hueToRgb(temp1,temp2,normH-0.3333333333333333);}return $.RgbColor_RgbColor($.toInt($.round(r)),$.toInt($.round(g)),$.toInt($.round(b)));},
 toRgb$0$bailout: function(state,env0,env1,env2){switch(state){case 1:t1=env0;break;case 2:normH=env0;t1=env1;break;case 3:t1=env0;break;case 4:t2=env0;normH=env1;t1=env2;break;}switch(state){case 0:var t1=this.h;case 1:state=0;var normH=$.div(t1,360);t1=this.s;case 2:state=0;default:if(state===3||state===0&&$.eqB(t1,0))switch(state){case 0:t1=this.l;case 3:state=0;var b=$.mul(t1,255);var g=b;var r=g;}else switch(state){case 0:var t2=this.l;case 4:state=0;if($.ltB(t2,0.5)){if(typeof t1!=='number')throw $.iae(t1);var temp2=$.mul(t2,1+t1);}else temp2=$.sub($.add(t2,t1),$.mul(t1,t2));if(typeof t2!=='number')throw $.iae(t2);t1=2*t2;if(typeof temp2!=='number')throw $.iae(temp2);var temp1=t1-temp2;r=255*$.HslColor__hueToRgb(temp1,temp2,$.add(normH,0.3333333333333333));g=255*$.HslColor__hueToRgb(temp1,temp2,normH);b=255*$.HslColor__hueToRgb(temp1,temp2,$.sub(normH,0.3333333333333333));}return $.RgbColor_RgbColor($.toInt($.round(r)),$.toInt($.round(g)),$.toInt($.round(b)));}},
 hashCode$0: function(){return $.Util_getHashCode([this.h,this.s,this.l]);},
 operator$eq$1: function(other){return !(other==null)&&$.eqB(other.get$h(),this.h)&&$.eqB(other.get$s(),this.s)&&$.eqB(other.get$l(),this.l);},
 toString$0: function(){return '{HslColor: '+$.S(this.h)+', '+$.S(this.s)+', '+$.S(this.l)+'}';}
};

$$.TarjanCycleDetect = {"":
 ["_index", "_stack", "_scc", "_lib1_list"],
 "super": "Object",
 _executeTarjan$0: function(){for(var t1=$.iterator($.ListImplementation_List$from(this._lib1_list.getSourceNodeSet$0(),'_TarjanNode'));t1.hasNext$0()===true;){var t2=t1.next$0();if($.eqB(t2.get$index(),-1))this._tarjan$1(t2);}return this._scc;},
 _tarjan$1: function(v){v.set$index(this._index);v.set$lowlink(this._index);var t1=this._index;if(typeof t1!=='number')return this._tarjan$1$bailout(1,v,t1,0,0,0);this._index=t1+1;var t3=this._stack;$.insertRange$3(t3,0,1,v);for(t1=$.iterator(this._lib1_list.getAdjacent$1(v));t1.hasNext$0()===true;){var t2=t1.next$0();var t4=t2.get$index();if(typeof t4!=='number')return this._tarjan$1$bailout(2,v,t4,t1,t3,t2);if(t4===-1){this._tarjan$1(t2);v.set$lowlink($.min(v.get$lowlink(),t2.get$lowlink()));}else{t4=$.indexOf$1(t3,t2);if(typeof t4!=='number')return this._tarjan$1$bailout(3,v,t4,t1,t2,t3);if(t4>=0)v.set$lowlink($.min(v.get$lowlink(),t2.get$index()));}}if($.eqB(v.get$lowlink(),v.get$index())){var component=$.ListImplementation_List(null,$.getRuntimeTypeInfo(this).TNode);var n=null;do{if(0>=t3.length)throw $.ioore(0);n=t3[0];$.removeRange(t3,0,1);component.push(n.get$value());}while(!$.eqB(n,v));this._scc.push(component);}},
 _tarjan$1$bailout: function(state,env0,env1,env2,env3,env4){switch(state){case 1:var v=env0;t1=env1;break;case 2:v=env0;t4=env1;t1=env2;t3=env3;t2=env4;break;case 3:v=env0;t4=env1;t1=env2;t2=env3;t3=env4;break;}switch(state){case 0:v.set$index(this._index);v.set$lowlink(this._index);var t1=this._index;case 1:state=0;this._index=$.add(t1,1);var t3=this._stack;$.insertRange$3(t3,0,1,v);t1=$.iterator(this._lib1_list.getAdjacent$1(v));default:L0:while(true)switch(state){case 0:if(!(t1.hasNext$0()===true))break L0;var t2=t1.next$0();var t4=t2.get$index();case 2:state=0;case 3:if(state===0&&$.eqB(t4,-1)){this._tarjan$1(t2);v.set$lowlink($.min(v.get$lowlink(),t2.get$lowlink()));}else switch(state){case 0:t4=$.indexOf$1(t3,t2);case 3:state=0;if($.geB(t4,0))v.set$lowlink($.min(v.get$lowlink(),t2.get$index()));}}if($.eqB(v.get$lowlink(),v.get$index())){var component=$.ListImplementation_List(null,$.getRuntimeTypeInfo(this).TNode);var n=null;do{if(0<0||0>=t3.length)throw $.ioore(0);n=t3[0];$.removeRange(t3,0,1);component.push(n.get$value());}while(!$.eqB(n,v));this._scc.push(component);}}}
};

$$._TarjanNode = {"":
 ["value?", "index=", "lowlink="],
 "super": "Object",
 hashCode$0: function(){return $.hashCode(this.value);},
 operator$eq$1: function(other){return $.eq(other.get$value(),this.value);}
};

$$._TarjanList = {"":
 ["_nodes"],
 "super": "Object",
 getSourceNodeSet$0: function(){return this._nodes.getKeys$0();},
 getAdjacent$1: function(v){var nodes=$.index(this._nodes,v);if(nodes==null)return [];else return nodes;}
};

$$.Attachable = {"":
 ["name?"],
 "super": "Object"
};

$$.AttachableObjectImpl = {"":
 ["propertyValues?"],
 "super": "DisposableImpl"
};

$$.PropertyValues = {"":
 ["_propertyValues", "_changeHandle", "_disposed"],
 "super": "DisposableImpl",
 _set$2: function(key,value){$.indexSet(this._propertyValues,key,value);this._changeHandle.fireEvent$1(key);},
 get$_set: function() { return new $.BoundClosure2(this, '_set$2'); },
 _isSet$1: function(key){return this._propertyValues.containsKey$1(key);},
 _lib1_remove$1: function(key){if(this._isSet$1(key)===true){this._propertyValues.remove$1(key);this._changeHandle.fireEvent$1(key);}},
 _getValueOrUndefined$3: function(key,obj,ifAbsent){if(this._isSet$1(key)===true)return $.index(this._propertyValues,key);else if(!(ifAbsent==null)){var value=ifAbsent.call$1(obj);this._set$2(key,value);return value;}else return $.CTC27;}
};

$$.Property = {"":
 ["defaultValue", "name"],
 "super": "Attachable",
 get$2: function(obj,ifAbsent){var coreValue=this.getCore$2(obj,ifAbsent);if(!(coreValue===$.CTC27))return coreValue;else return this.defaultValue;},
 get$1: function(obj) {
  return this.get$2(obj,null)
},
 getCore$2: function(obj,ifAbsent){return obj.get$propertyValues()._getValueOrUndefined$3(this,obj,ifAbsent);},
 set$2: function(obj,value){obj.get$propertyValues()._set$2(this,value);},
 clear$1: function(obj){obj.get$propertyValues()._lib1_remove$1(this);},
 toString$0: function(){return 'Property \''+$.S(this.name)+'\'';}
};

$$._UndefinedValue = {"":
 [],
 "super": "Object"
};

$$.PElement = {"":
 [],
 "super": "AttachableObjectImpl",
 clip$0: function() { return this.clip.call$0(); },
 get$width: function(){return this._width;},
 set$width: function(value){this._width=value;this.invalidateDraw$0();},
 get$height: function(){return this._height;},
 set$height: function(value){this._height=value;this.invalidateDraw$0();},
 get$size: function(){return $.Size$(this._width,this._height);},
 get$visualChildCount: function(){return 0;},
 get$invalidated: function(){return this._invalidatedEventHandle;},
 getTransform$0: function(){var tx=$.AffineTransform$(1,0,0,1,0,0);$.forEach(this._transforms,tx.get$concatenate());return tx;},
 draw$1: function(ctx){this.update$0();var dirty=this._lastDrawSize==null;this.drawCore$1(ctx);return dirty;},
 update$0: function(){this._updatedEventHandle.fireEvent$1($.CTC24);},
 drawCore$1: function(ctx){if(this.cacheEnabled===true)this._drawCached$1(ctx);else this._drawNormal$1(ctx);},
 addTransform$0: function(){var tx=$.AffineTransform$(1,0,0,1,0,0);this._transforms.push(tx);return tx;},
 invalidateDraw$0: function(){if(!(this._lastDrawSize==null)){this._lastDrawSize=null;this._invalidateParent$0();}},
 getVisualChild$1: function(index){throw $.$$throw('no children for this type');},
 registerParent$1: function(parent$){this._lib3_parent=parent$;},
 _drawCached$1: function(ctx){var t1=this._cacheCanvas;if(t1==null||!$.eqB($.CanvasUtil_getCanvasSize(t1),this._lastDrawSize)){if(this._cacheCanvas==null)this._cacheCanvas=$._Elements_CanvasElement(null,null);t1=this.get$width();this._cacheCanvas.set$width(t1);t1=this.get$height();this._cacheCanvas.set$height(t1);this._drawInternal$1(this._cacheCanvas.get$context2d());}ctx.save$0();$.CanvasUtil_transform(ctx,this.getTransform$0());ctx.drawImage$3(this._cacheCanvas,0,0);ctx.restore$0();},
 _drawNormal$1: function(ctx){var tx=this.getTransform$0();if(this._isClipped$2(tx,ctx)===true)return;ctx.save$0();$.CanvasUtil_transform(ctx,tx);if(this.clip===true){ctx.beginPath$0();ctx.rect$4(0,0,this.get$width(),this.get$height());ctx.clip$0();}this._drawInternal$1(ctx);ctx.restore$0();},
 _drawInternal$1: function(ctx){var t1=this._alpha;if(!(t1==null))ctx.set$globalAlpha(t1);this.drawOverride$1(ctx);this._lastDrawSize=this.get$size();},
 _isClipped$2: function(tx,ctx){if(this.clip===true);return false;},
 _invalidateParent$0: function(){this._invalidatedEventHandle.fireEvent$1($.CTC24);this._lib3_parent.childInvalidated$1(this);}
};

$$.ElementParentImpl = {"":
 [],
 "super": "PElement",
 childInvalidated$1: function(child){this.invalidateDraw$0();},
 update$0: function(){this._forEach$1(new $.ElementParentImpl_update_anon());$.PElement.prototype.update$0.call(this);},
 drawOverride$1: function(ctx){this._forEach$1(new $.ElementParentImpl_drawOverride_anon(ctx));},
 _forEach$1: function(f){var length$=this.get$visualChildCount();if(typeof length$!=='number')return this._forEach$1$bailout(1,f,length$);for(var i=0;i<length$;++i)f.call$1(this.getVisualChild$1(i));},
 _forEach$1$bailout: function(state,f,length$){for(var i=0;$.ltB(i,length$);++i)f.call$1(this.getVisualChild$1(i));}
};

$$.Stage = {"":
 ["_lib3_canvas", "_lib3_element?", "_invalidatedEventHandle", "_ctx", "propertyValues", "_disposed"],
 "super": "AttachableObjectImpl",
 get$invalidated: function(){return this._invalidatedEventHandle;},
 get$rootElement: function(){return this._lib3_element;},
 draw$0: function(){var t1=this._ctx;var t2=t1==null;var t3=this._lib3_canvas;if(t2)this._ctx=t3.get$context2d();else t1.clearRect$4(0,0,t3.get$width(),t3.get$height());return this._lib3_element.draw$1(this._ctx);},
 childInvalidated$1: function(child){this._invalidatedEventHandle.fireEvent$1($.CTC24);},
 Stage$2: function(_canvas,_element){this._lib3_element.registerParent$1(this);}
};

$$.Dragger = {"":
 ["_element?", "_dragDeltaHandle", "_dragStartHandle", "_clientLoc"],
 "super": "Object",
 get$dragDelta: function(){return this._dragDeltaHandle;},
 get$dragStart: function(){return this._dragStartHandle;},
 get$isDragging: function(){return !(this._clientLoc==null);},
 _onMouseDown$1: function(event$){var args=$.CancelableEventArgs$();this._dragStartHandle.fireEvent$1(args);if(args.get$isCanceled()!==true){event$.preventDefault$0();this._clientLoc=$.Coordinate$(event$.get$clientX(),event$.get$clientY());}},
 get$_onMouseDown: function() { return new $.BoundClosure0(this, '_onMouseDown$1'); },
 _handleMove$1: function(event$){if(this.get$isDragging()===true){var newLoc=$.Coordinate$(event$.get$clientX(),event$.get$clientY());var delta=newLoc.operator$sub$1(this._clientLoc);this._dragDeltaHandle.fireEvent$1(delta);this._clientLoc=newLoc;}},
 get$_handleMove: function() { return new $.BoundClosure0(this, '_handleMove$1'); },
 _endDrag$1: function(event$){if(this.get$isDragging()===true)this._clientLoc=null;},
 get$_endDrag: function() { return new $.BoundClosure0(this, '_endDrag$1'); },
 Dragger$1: function(_element){$.add$1(this._element.get$on().get$mouseDown(),this.get$_onMouseDown());$.add$1($.window().get$on().get$mouseMove(),this.get$_handleMove());$.add$1($.window().get$on().get$mouseUp(),this.get$_endDrag());$.add$1($.window().get$on().get$blur(),this.get$_endDrag());}
};

$$.HtmlView = {"":
 [],
 "super": "Object",
 get$node: function(){return this._node;},
 markDirty$0: function(){this._dirty=true;},
 draw$0: function(){if(this._dirty===true){this.updateElement$0();this._dirty=false;}},
 HtmlView$1: function(_node){$.requireArgumentNotNull(this._node,'node');this._dirty=true;}
};

$$.ElectionPlace = {"":
 ["place?", "_items"],
 "super": "ReadOnlyCollection",
 toString$0: function(){return 'Place: '+$.S(this.place)+'; '+$.S($.Enumerable.prototype.toString$0.call(this));},
 ElectionPlace$2: function(place,candidates){}
};

$$.Election = {"":
 [],
 "super": "Object"
};

$$.Ballot = {"":
 ["voter?"],
 "super": "Object",
 operator$eq$1: function(other){return !(other==null)&&$.eqB(other.get$voter(),this.voter);},
 hashCode$0: function(){return $.hashCode(this.voter);}
};

$$.RankedBallot = {"":
 ["rank?"],
 "super": "PluralityBallot",
 toString$0: function(){return '[RankedBallot for \''+$.S(this.voter)+'\', ranked '+$.S($.get$length(this.rank))+' candidates]';}
};

$$.PluralityBallot = {"":
 ["choice?"],
 "super": "Ballot"
};

$$.PluralityElection = {"":
 ["ballots?", "_ballotGroup", "places?"],
 "super": "Election",
 get$candidates: function(){return this._ballotGroup.getKeys$0();}
};

$$.PluralityElectionPlace = {"":
 ["voteCount?", "place", "_items"],
 "super": "ElectionPlace",
 toString$0: function(){return 'Votes: '+$.S(this.voteCount)+'; '+$.S($.ElectionPlace.prototype.toString$0.call(this));},
 PluralityElectionPlace$3: function(place,candidates,voteCount){}
};

$$.CondorcetElection = {"":
 ["_pairs", "_profiles", "ballots?", "places?"],
 "super": "Election",
 get$candidates: function(){return this._profiles.getKeys$0();},
 getPair$2: function(c1,c2){var filter=$.filter(this._pairs,new $.CondorcetElection_getPair_anon(c1,c2));if($.isEmpty(filter)===true)return;else return $.iterator(filter).next$0().flip$2(c1,c2);}
};

$$.CondorcetPair = {"":
 ["ballots?", "firstOverSecond?", "secondOverFirst?", "Item1", "Item2"],
 "super": "Tuple",
 get$winner: function(){var t1=this.firstOverSecond;var t2=this.secondOverFirst;if($.gtB(t1,t2))return this.Item1;else if($.gtB(t2,t1))return this.Item2;else return;},
 get$isTie: function(){return $.eq(this.firstOverSecond,this.secondOverFirst);},
 hashCode$0: function(){return $.Util_getHashCode([this.Item1,this.Item2]);},
 matches$2: function(can1,can2){$.requireArgumentNotNull(can1,'can1');$.requireArgumentNotNull(can2,'can2');$.requireArgument(!$.eqB(can1,can2),'can1 and can2 must be different',null);if($.gtB($.compareTo(can1,can2),0)){var t0=can2;can2=can1;can1=t0;}return $.eqB(this.Item1,can1)&&$.eqB(this.Item2,can2);},
 flip$2: function(can1,can2){var t1=this.Item1;var t2=this.Item2;if($.gtB($.compareTo(t1,t2),0))throw $.$$throw('already flipped!');$.requireArgumentNotNull(can1,'can1');$.requireArgumentNotNull(can2,'can2');$.requireArgument(!$.eqB(can1,can2),'can1 and can2 must be different',null);if($.gtB($.compareTo(can1,can2),0)){var t0=can2;can2=can1;can1=t0;var flipped=true;}else flipped=false;$.requireArgument($.eq(can1,t1),'can1',null);$.requireArgument($.eq(can2,t2),'can1',null);if(flipped)return $.CondorcetPair$_internal(can2,can1,this.ballots,this.secondOverFirst,this.firstOverSecond);else return this;}
};

$$.CondorcetCandidateProfile = {"":
 ["candidate", "lostTo", "beat", "tied"],
 "super": "Object",
 hashCode$0: function(){return $.hashCode(this.candidate);},
 toString$0: function(){return '[ '+$.S(this.candidate)+': Beat: '+$.S($.get$length(this.beat))+', Tied: '+$.S($.get$length(this.tied))+', Lost to: '+$.S($.get$length(this.lostTo));}
};

$$.MapPlayer = {"":
 ["_lib4_id?", "name?", "_lib4_location="],
 "super": "Object",
 get$location: function(){return this._lib4_location;},
 set$location: function(value){$.requireArgumentNotNull(value,'value');this._lib4_location=value;},
 get$id: function(){return this._lib4_id.get$id();},
 compareTo$1: function(other){return $.compareTo(this._lib4_id,other.get$_lib4_id());},
 hashCode$0: function(){return $.hashCode(this._lib4_id);},
 operator$eq$1: function(other){return !(other==null)&&$.eqB(other.get$_lib4_id(),this._lib4_id);},
 toString$0: function(){var t1=this.name;if(t1==null)return 'MapPlayer at ['+$.S($.toStringAsFixed(this._lib4_location.get$x(),1))+', '+$.S($.toStringAsFixed(this._lib4_location.get$y(),1))+']';else return t1;}
};

$$.DistanceElection = {"":
 ["candidates?", "ballots?", "places?"],
 "super": "Election"
};

$$.DistanceElectionPlace = {"":
 ["avgDistance?", "avgDistanceSquared?", "place", "_items"],
 "super": "ElectionPlace"
};

$$.DistanceBallot = {"":
 ["_distances", "rank", "choice", "voter"],
 "super": "RankedBallot",
 getDistance$1: function(candidate){var t1=this._distances;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.getDistance$1$bailout(1,t1,candidate);if(candidate!==(candidate|0))throw $.iae(candidate);if(candidate<0||candidate>=t1.length)throw $.ioore(candidate);return t1[candidate];},
 getDistance$1$bailout: function(state,t1,candidate){return $.index(t1,candidate);}
};

$$.LocationData = {"":
 ["candidates?", "voters?"],
 "super": "Object",
 cloneAndRemove$1: function(mp){$.requireArgumentNotNull(mp,'mp');var newCans=this.candidates.where$1(new $.LocationData_cloneAndRemove_anon(mp)).toReadOnlyCollection$0();return $.LocationData$(this.voters,newCans);},
 cloneAndAddCandidate$0: function(){var newCans=this.candidates.toList$0();if(typeof newCans!=='string'&&(typeof newCans!=='object'||newCans===null||newCans.constructor!==Array&&!newCans.is$JavaScriptIndexingBehavior()))return this.cloneAndAddCandidate$0$bailout(1,newCans);for(var i=0;t1=newCans.length,i<t1;++i){if(i<0||i>=t1)throw $.ioore(i);if($.gtB($.sub($.charCodeAt(newCans[i].get$name(),0),65),i))break;}var newName=$.LocationData_getCandidateName(i);$.insertRange$3(newCans,i,1,$.MapPlayer$($.Vector$($.rnd().nextDouble$0(),$.rnd().nextDouble$0()).scale$1(20),newName));return $.LocationData$(this.voters,$.ReadOnlyCollection$(newCans));var t1;},
 cloneAndAddCandidate$0$bailout: function(state,newCans){for(var i=0;$.ltB(i,$.get$length(newCans));++i)if($.gtB($.sub($.charCodeAt($.index(newCans,i).get$name(),0),65),i))break;var newName=$.LocationData_getCandidateName(i);$.insertRange$3(newCans,i,1,$.MapPlayer$($.Vector$($.rnd().nextDouble$0(),$.rnd().nextDouble$0()).scale$1(20),newName));return $.LocationData$(this.voters,$.ReadOnlyCollection$(newCans));},
 LocationData$2: function(voters,candidates){}
};

$$.RootMapElement = {"":
 ["_voterMap", "_candidateMap", "_tx?", "_candidatesMovedHandle", "_averageCloseness", "_bounds", "_radius=", "_transforms", "cacheEnabled", "_updatedEventHandle", "_invalidatedEventHandle", "_cacheCanvas", "_width", "_height", "_alpha", "_lastDrawSize", "clip", "_lib3_parent", "propertyValues", "_disposed"],
 "super": "ElementParentImpl",
 get$candidatesMoved: function(){return this._candidatesMovedHandle;},
 candidatesMoved$0: function() { return this.get$candidatesMoved().call$0(); },
 get$visualChildCount: function(){return 2;},
 getVisualChild$1: function(index){switch(index){case 0:return this._voterMap;case 1:return this._candidateMap;default:throw $.$$throw('bad index, foo!');}},
 set$locationData: function(data){this.set$voters(data.get$voters());this.set$candidates(data.get$candidates());this.invalidateDraw$0();},
 get$voters: function(){return this._voterMap.get$players();},
 set$voterHexMap: function(value){this._voterMap.set$playerHexMap(value);},
 set$voters: function(value){$.requireArgumentNotNull(value,'value');var vals=$.Tuple$(1,$.Rect$(0,0,20,20),'num','Rect');this._averageCloseness=vals.Item1;this._bounds=vals.Item2;this._radius=null;this._voterMap.set$players(value);},
 set$candidates: function(value){$.requireArgumentNotNull(value,'value');this._candidateMap.set$players(value);},
 set$showOnlyPlayers: function(value){this._candidateMap.set$showOnlyPlayers(value);},
 dragCandidate$2: function(candidate,delta){var can=$.$$(this._candidateMap.get$players()).single$1(new $.RootMapElement_dragCandidate_anon(candidate));var t1=this._tx;var newCanLocPix=$.add(t1.transformCoordinate$1(candidate.get$location()),delta);can.set$location($.CTC30.constrain$1(t1.createInverse$0().transformCoordinate$1(newCanLocPix)));this._candidatesMovedHandle.fireEvent$1($.CTC24);},
 update$0: function(){var t1=this._bounds;if(!(t1==null)&&this._radius==null){var dataScale=$.Size$($.add(t1.get$width(),this._averageCloseness),$.add(this._bounds.get$height(),this._averageCloseness));t1=$.gtB(dataScale.get$aspectRatio(),this.get$size().get$aspectRatio());var t2=dataScale.width;var t3=dataScale.height;if(t1){var scale=$.div(this.get$width(),t2);var offsetY=$.div($.sub($.div(this.get$height(),scale),t3),2);var offsetX=0;}else{scale=$.div(this.get$height(),t3);offsetX=$.div($.sub($.div(this.get$width(),scale),t2),2);offsetY=0;}t1=this._tx;t1.setToScale$2(scale,scale);t1.translate$2($.add($.add(this._bounds.get$left(),$.div(this._averageCloseness,2)),offsetX),$.add($.add(this._bounds.get$top(),$.div(this._averageCloseness,2)),offsetY));this._radius=$.mul(this._averageCloseness,0.3);}$.forEach([this._voterMap,this._candidateMap],new $.RootMapElement_update_anon(this));$.ElementParentImpl.prototype.update$0.call(this);},
 RootMapElement$2: function(w,h){this._voterMap.registerParent$1(this);this._candidateMap.registerParent$1(this);}
};

$$.VoterMapElement = {"":
 ["_players", "_tx?", "_radius=", "_lib6_map", "_transforms", "cacheEnabled", "_updatedEventHandle", "_invalidatedEventHandle", "_cacheCanvas", "_width", "_height", "_alpha", "_lastDrawSize", "clip", "_lib3_parent", "propertyValues", "_disposed"],
 "super": "PElement",
 setTransform$1: function(value){$.requireArgumentNotNull(value,'value');this._tx.setFromTransfrom$1(value);this.invalidateDraw$0();},
 get$players: function(){return this._players;},
 set$players: function(value){$.requireArgumentNotNull(value,'value');var t1=this._players;$.clear(t1);$.addAll(t1,value);this.invalidateDraw$0();},
 set$playerHexMap: function(value){this._lib6_map=value;this.invalidateDraw$0();},
 drawOverride$1: function(ctx){for(var t1=$.iterator(this._players);t1.hasNext$0()===true;)this._drawPlayer$2(ctx,t1.next$0());},
 _drawPlayer$2: function(ctx,player){var t1=this._lib6_map;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this._drawPlayer$2$bailout(1,ctx,player,t1,0,0);if(player!==(player|0))throw $.iae(player);if(player<0||player>=t1.length)throw $.ioore(player);var hex=t1[player];if(typeof hex!=='string')return this._drawPlayer$2$bailout(2,ctx,player,hex,0,0);ctx.set$fillStyle(hex);t1=this._tx;var txLoc=t1.transformCoordinate$1(player.get$location());var t2=txLoc.get$x();var t3=txLoc.get$y();var t4=this._radius;if(typeof t4!=='number')return this._drawPlayer$2$bailout(3,ctx,t1,t4,t2,t3);t1=t1.get$scaleX();if(typeof t1!=='number')return this._drawPlayer$2$bailout(4,ctx,t1,t4,t2,t3);$.CanvasUtil_centeredCircle(ctx,t2,t3,t4*t1);ctx.fill$0();},
 _drawPlayer$2$bailout: function(state,env0,env1,env2,env3,env4){switch(state){case 1:var ctx=env0;var player=env1;t1=env2;break;case 2:ctx=env0;player=env1;hex=env2;break;case 3:ctx=env0;t1=env1;t4=env2;t2=env3;t3=env4;break;case 4:ctx=env0;t1=env1;t4=env2;t2=env3;t3=env4;break;}switch(state){case 0:var t1=this._lib6_map;case 1:state=0;var hex=$.index(t1,player);case 2:state=0;ctx.set$fillStyle(hex==null?'#999999':hex);t1=this._tx;var txLoc=t1.transformCoordinate$1(player.get$location());var t2=txLoc.get$x();var t3=txLoc.get$y();var t4=this._radius;case 3:state=0;t1=t1.get$scaleX();case 4:state=0;$.CanvasUtil_centeredCircle(ctx,t2,t3,$.mul(t4,t1));ctx.fill$0();}},
 VoterMapElement$2: function(w,h){this._radius=0.3;this._lib6_map=$.HashMapImplementation$('MapPlayer','String');}
};

$$.CandidateMapElement = {"":
 ["_players", "_tx?", "_radius=", "_lib6_elements", "_showOnlyPlayers", "_transforms", "cacheEnabled", "_updatedEventHandle", "_invalidatedEventHandle", "_cacheCanvas", "_width", "_height", "_alpha", "_lastDrawSize", "clip", "_lib3_parent", "propertyValues", "_disposed"],
 "super": "ElementParentImpl",
 get$visualChildCount: function(){this._ensureElements$0();return $.get$length(this._lib6_elements);},
 getVisualChild$1: function(index){this._ensureElements$0();var t1=this._lib6_elements;if(typeof t1!=='string'&&(typeof t1!=='object'||t1===null||t1.constructor!==Array&&!t1.is$JavaScriptIndexingBehavior()))return this.getVisualChild$1$bailout(1,index,t1);if(index!==(index|0))throw $.iae(index);if(index<0||index>=t1.length)throw $.ioore(index);return t1[index];},
 getVisualChild$1$bailout: function(state,index,t1){return $.index(t1,index);},
 setTransform$1: function(value){$.requireArgumentNotNull(value,'value');this._tx.setFromTransfrom$1(value);this.invalidateDraw$0();},
 get$players: function(){return this._players;},
 set$players: function(value){$.requireArgumentNotNull(value,'value');var t1=this._players;$.clear(t1);$.addAll(t1,value);this._lib6_elements=null;this.invalidateDraw$0();},
 set$showOnlyPlayers: function(value){if(value==null)this._showOnlyPlayers=null;else this._showOnlyPlayers=$.$$(value).toReadOnlyCollection$0();if(this._lib6_elements==null)this.invalidateDraw$0();else this._updateCandidateElements$0();},
 _ensureElements$0: function(){if(this._lib6_elements==null){this._lib6_elements=$.ListImplementation_List(null,'CandidateElement');for(var t1=$.iterator(this._players),t2=this._tx;t1.hasNext$0()===true;){var t3=t1.next$0();var rgb=$.HslColor_HslColor($.LocationData_getHue(t3),0.5,0.6).toRgb$0();var ce=$.CandidateElement$($.mul(this._radius,4),$.mul(this._radius,4),rgb.toHex$0(),t3);ce.registerParent$1(this);var tempTx=ce.addTransform$0();tempTx.concatenate$1(t2);var t4=t3.get$location().get$x();var t5=this._radius;if(typeof t5!=='number')throw $.iae(t5);t4=$.sub(t4,2*t5);var t6=t3.get$location().get$y();var t7=this._radius;if(typeof t7!=='number')throw $.iae(t7);tempTx.translate$2(t4,$.sub(t6,2*t7));$.add$1(this._lib6_elements,ce);}this._updateCandidateElements$0();}},
 _updateCandidateElements$0: function(){for(var t1=$.iterator(this._lib6_elements);t1.hasNext$0()===true;){var t2=t1.next$0();var t3=this._showOnlyPlayers;t2.set$hidden(!(t3==null)&&$.ltB($.indexOf$1(t3,t2.get$player()),0));}},
 CandidateMapElement$2: function(w,h){this.set$showOnlyPlayers(null);}
};

$$.CandidateElement = {"":
 ["_color", "player?", "_text", "_tx?", "_hidden", "_transforms", "cacheEnabled", "_updatedEventHandle", "_invalidatedEventHandle", "_cacheCanvas", "_width", "_height", "_alpha", "_lastDrawSize", "clip", "_lib3_parent", "propertyValues", "_disposed"],
 "super": "PElement",
 get$hidden: function(){return this._hidden;},
 set$hidden: function(value){if(!$.eqB(value,this._hidden)){this._hidden=value;this.invalidateDraw$0();}},
 drawOverride$1: function(ctx){if(this.get$hidden()===true){ctx.set$globalAlpha(0.3);ctx.set$fillStyle('#999999');}else{var shadowDistance=$.Mouse_isMouseDirectlyOver(this)===true?4:2;ctx.set$shadowColor('black');ctx.set$shadowBlur(6);ctx.set$shadowOffsetX(shadowDistance);ctx.set$shadowOffsetY(shadowDistance);ctx.set$fillStyle(this._color);}$.CanvasUtil_ellipse(ctx,0,0,this.get$width(),this.get$height());ctx.fill$0();ctx.set$shadowColor('transparent');ctx.set$font('1px Helvetica');ctx.set$textAlign('center');ctx.set$textBaseline('top');ctx.set$fillStyle('black');ctx.fillText$3(this._text,$.div(this.get$width(),2),0);},
 CandidateElement$4: function(w,h,_color,p){this._tx=this.addTransform$0();},
 is$CandidateElement: true
};

$$.CandidateManagerView = {"":
 ["_requestRemoveCandidateHandle", "_requestNewCandidateHandle", "_candidates", "_node", "_dirty"],
 "super": "HtmlView",
 set$candidates: function(value){this._candidates=value;this.markDirty$0();},
 get$candidateRemoveRequest: function(){return this._requestRemoveCandidateHandle;},
 get$newCandidateRequest: function(){return this._requestNewCandidateHandle;},
 updateElement$0: function(){$.clear(this.get$node().get$elements());var table=$._Elements_TableElement();var row=table.insertRow$1(-1);var cell=row.insertCell$1(-1);cell.set$colSpan(2);var addButton=$._Elements_ButtonElement();addButton.set$text('Add Candidate');if($.ltB($.get$length(this._candidates),26))$.add$1(addButton.get$on().get$click(),this.get$_requestNewCandidate());else addButton.set$disabled(true);$.add$1(cell.get$elements(),addButton);var t1=this._candidates;if(!(t1==null))for(t1=$.iterator(t1);t1.hasNext$0()===true;){var t2=t1.next$0();row=table.insertRow$1(-1);var hue=$.LocationData_getHue(t2);if(!(hue==null)){var t3=$.HslColor_HslColor(hue,1,0.75).toRgb$0().toHex$0();row.get$style().set$background(t3);}cell=row.insertCell$1(-1);$.add$1(cell.get$classes(),'candidate-cell');cell.set$innerHTML($.toString(t2));cell=row.insertCell$1(-1);var deleteButton=$._Elements_ButtonElement();deleteButton.set$text('Delete');$.indexSet(deleteButton.get$dataAttributes(),'candidate-id',$.toString(t2.get$id()));if($.gtB($.get$length(this._candidates),1))$.add$1(deleteButton.get$on().get$click(),this.get$_deleteClick());else deleteButton.set$disabled(true);$.add$1(cell.get$elements(),deleteButton);}$.add$1(this.get$node().get$elements(),table);},
 _requestNewCandidate$1: function(args){var source=args.get$toElement();this._requestNewCandidateHandle.fireEvent$1($.CTC24);source.set$disabled(true);},
 get$_requestNewCandidate: function() { return new $.BoundClosure0(this, '_requestNewCandidate$1'); },
 _deleteClick$1: function(args){var source=args.get$toElement();this._removeCandidateWithId$1($.parseInt($.index(source.get$dataAttributes(),'candidate-id')));source.set$disabled(true);},
 get$_deleteClick: function() { return new $.BoundClosure0(this, '_deleteClick$1'); },
 _removeCandidateWithId$1: function(id){var candidate=this._candidates.single$1(new $.CandidateManagerView__removeCandidateWithId_anon(id));this._requestRemoveCandidateHandle.fireEvent$1(candidate);}
};

$$.PluralityView = {"":
 ["_election", "_node", "_dirty"],
 "super": "HtmlView",
 set$election: function(election){this._election=election;this.markDirty$0();},
 updateElement$0: function(){$.clear(this.get$node().get$elements());var table=$._Elements_TableElement();var row=table.insertRow$1(-1);var cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML('Place');cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML('Candidate');cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);$.add$1(row.get$classes(),'row-odd');cell.set$innerHTML('Votes');var t1=this._election;if(!(t1==null))for(var t2=$.iterator(t1.get$places()),evenCandidateRow=true,evenPlaceRow=true;t2.hasNext$0()===true;){t1=t2.next$0();for(var t3=$.iterator(t1),first=true;t3.hasNext$0()===true;){var t4=t3.next$0();row=table.insertRow$1(-1);var t5=row.get$classes();$.add$1(t5,evenPlaceRow?'row-even':'row-odd');if(first){cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);$.add$1(cell.get$classes(),'place-number');cell.set$rowSpan($.get$length(t1));cell.set$innerHTML($.toString(t1.get$place()));}cell=row.insertCell$1(-1);$.add$1(cell.get$classes(),'candidate-cell');var hue=$.LocationData_getHue(t4);if(!(hue==null)){t5=$.HslColor_HslColor(hue,1,0.75).toRgb$0().toHex$0();cell.get$style().set$background(t5);}cell.set$innerHTML($.toString(t4));if(first){cell=row.insertCell$1(-1);cell.set$rowSpan($.get$length(t1));cell.set$innerHTML($.toString(t1.get$voteCount()));$.add$1(cell.get$classes(),'vote-count');first=false;}evenCandidateRow=!evenCandidateRow;}evenPlaceRow=!evenPlaceRow;}$.add$1(this.get$node().get$elements(),table);}
};

$$.DistanceView = {"":
 ["_election", "_node", "_dirty"],
 "super": "HtmlView",
 set$election: function(value){this._election=value;this.markDirty$0();},
 updateElement$0: function(){$.clear(this.get$node().get$elements());var table=$._Elements_TableElement();var row=table.insertRow$1(-1);$.add$1(row.get$classes(),'row-odd');var cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML('Place');cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML('Candidate');cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML('Avg Dist');cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML('Avg Dist\xb2');var t1=this._election;if(!(t1==null))for(var t2=$.iterator(t1.get$places()),evenCandidateRow=true,evenPlaceRow=true;t2.hasNext$0()===true;){t1=t2.next$0();for(var t3=$.iterator(t1),first=true;t3.hasNext$0()===true;){var t4=t3.next$0();row=table.insertRow$1(-1);var t5=row.get$classes();$.add$1(t5,evenPlaceRow?'row-even':'row-odd');if(first){cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);$.add$1(cell.get$classes(),'place-number');cell.set$rowSpan($.get$length(t1));cell.set$innerHTML($.toString(t1.get$place()));}cell=row.insertCell$1(-1);$.add$1(cell.get$classes(),'candidate-cell');var hue=$.LocationData_getHue(t4);if(!(hue==null)){t5=$.HslColor_HslColor(hue,1,0.75).toRgb$0().toHex$0();cell.get$style().set$background(t5);}cell.set$innerHTML($.toString(t4));if(first){cell=row.insertCell$1(-1);cell.set$rowSpan($.get$length(t1));cell.set$innerHTML($.toStringAsFixed(t1.get$avgDistance(),2));$.add$1(cell.get$classes(),'vote-count');var cell0=row.insertCell$1(-1);cell0.set$rowSpan($.get$length(t1));cell0.set$innerHTML($.toStringAsFixed(t1.get$avgDistanceSquared(),2));$.add$1(cell0.get$classes(),'vote-count');cell=cell0;first=false;}evenCandidateRow=!evenCandidateRow;}evenPlaceRow=!evenPlaceRow;}$.add$1(this.get$node().get$elements(),table);}
};

$$.CondorcetView = {"":
 ["_hoverChangedHandle", "_election", "_candidates", "_hoveringPair", "_node", "_dirty"],
 "super": "HtmlView",
 set$election: function(election){this._election=election;this._candidates=null;this.markDirty$0();},
 get$hoverChanged: function(){return this._hoverChangedHandle;},
 get$hoveringPair: function(){return this._hoveringPair;},
 updateElement$0: function(){$.clear(this.get$node().get$elements());var table=$._Elements_TableElement();var row=table.insertRow$1(-1);var cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);$.add$1(row.get$classes(),'row-odd');cell.set$innerHTML('Place');cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML('Candidate');var t1=this._election;if(!(t1==null)){this._candidates=t1.get$places().selectMany$1(new $.CondorcetView_updateElement_anon()).toReadOnlyCollection$0();var colors=this._candidates.toHashMap$1(new $.CondorcetView_updateElement_anon0());if(typeof colors!=='string'&&(typeof colors!=='object'||colors===null||colors.constructor!==Array&&!colors.is$JavaScriptIndexingBehavior()))return this.updateElement$0$bailout(1,colors,cell,row,table,0);var darkColors=this._candidates.toHashMap$1(new $.CondorcetView_updateElement_anon1());if(typeof darkColors!=='string'&&(typeof darkColors!=='object'||darkColors===null||darkColors.constructor!==Array&&!darkColors.is$JavaScriptIndexingBehavior()))return this.updateElement$0$bailout(2,colors,cell,row,darkColors,table);for(t1=$.iterator(this._candidates);t1.hasNext$0()===true;){var t2=t1.next$0();cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML($.toString(t2));if(t2!==(t2|0))throw $.iae(t2);if(t2<0||t2>=colors.length)throw $.ioore(t2);t2=colors[t2];cell.get$style().set$background(t2);cell.set$colSpan(3);}for(var t1=$.iterator(this._election.get$places()),evenCandidateRow=true,evenPlaceRow=true;t1.hasNext$0()===true;){t2=t1.next$0();for(var t3=$.iterator(t2),first=true;t3.hasNext$0()===true;){var t4=t3.next$0();row=table.insertRow$1(-1);var t5=row.get$classes();$.add$1(t5,evenPlaceRow?'row-even':'row-odd');if(first){cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);$.add$1(cell.get$classes(),'place-number');cell.set$rowSpan($.get$length(t2));cell.set$innerHTML($.toString(t2.get$place()));first=false;}cell=row.insertCell$1(-1);$.add$1(cell.get$classes(),'candidate-cell');if(t4!==(t4|0))throw $.iae(t4);if(t4<0||t4>=colors.length)throw $.ioore(t4);t5=colors[t4];cell.get$style().set$background(t5);cell.set$innerHTML($.toString(t4));for(t5=$.iterator(this._candidates);t5.hasNext$0()===true;){var t6=t5.next$0();if($.eqB(t6,t4)){cell=row.insertCell$1(-1);cell.get$style().set$background('#999999');cell.set$colSpan(3);}else{var pair=this._election.getPair$2(t4,t6);if(t4===pair.get$winner()){var t7=darkColors.length;if(t4<0||t4>=t7)throw $.ioore(t4);var leftColor=darkColors[t4];if(t6!==(t6|0))throw $.iae(t6);if(t6<0||t6>=t7)throw $.ioore(t6);var rightColor=darkColors[t6];var middleText='&gt;';var cellClass='winner';}else if($.eqB(t6,pair.get$winner())){t7=colors.length;if(t4<0||t4>=t7)throw $.ioore(t4);leftColor=colors[t4];if(t6!==(t6|0))throw $.iae(t6);if(t6<0||t6>=t7)throw $.ioore(t6);rightColor=colors[t6];middleText='&lt;';cellClass='loser';}else{t7=darkColors.length;if(t4<0||t4>=t7)throw $.ioore(t4);leftColor=darkColors[t4];if(t6!==(t6|0))throw $.iae(t6);if(t6<0||t6>=t7)throw $.ioore(t6);rightColor=darkColors[t6];middleText='=';cellClass='tie';}var cellData=this._getPairElementName$2(t4,t6);cell=row.insertCell$1(-1);cell.set$innerHTML($.toString(pair.get$firstOverSecond()));cell.get$style().set$color(leftColor);$.add$1(cell.get$classes(),'vote-count');$.add$1(cell.get$classes(),'pair-cell');$.add$1(cell.get$classes(),cellData);$.add$1(cell.get$classes(),cellClass);$.add$1(cell.get$classes(),'left_value');$.indexSet(cell.get$dataAttributes(),'pair-ids',cellData);var cell0=row.insertCell$1(-1);cell0.set$innerHTML(middleText);$.add$1(cell0.get$classes(),'pair-cell');$.add$1(cell0.get$classes(),cellClass);$.add$1(cell0.get$classes(),cellData);$.indexSet(cell0.get$dataAttributes(),'pair-ids',cellData);var cell1=row.insertCell$1(-1);cell1.set$innerHTML($.toString(pair.get$secondOverFirst()));cell1.get$style().set$color(rightColor);$.add$1(cell1.get$classes(),'vote-count');$.add$1(cell1.get$classes(),'right_value');$.add$1(cell1.get$classes(),cellClass);$.add$1(cell1.get$classes(),'pair-cell');$.add$1(cell1.get$classes(),cellData);$.indexSet(cell1.get$dataAttributes(),'pair-ids',cellData);cell=cell1;}}evenCandidateRow=!evenCandidateRow;}evenPlaceRow=!evenPlaceRow;}}$.add$1(table.get$on().get$mouseMove(),this.get$_onMouseOver());$.add$1(table.get$on().get$mouseOut(),this.get$_onMouseOut());$.add$1(this.get$node().get$elements(),table);},
 updateElement$0$bailout: function(state,env0,env1,env2,env3,env4){switch(state){case 1:colors=env0;cell=env1;row=env2;table=env3;break;case 2:colors=env0;cell=env1;row=env2;darkColors=env3;table=env4;break;}switch(state){case 0:$.clear(this.get$node().get$elements());var table=$._Elements_TableElement();var row=table.insertRow$1(-1);var cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);$.add$1(row.get$classes(),'row-odd');cell.set$innerHTML('Place');cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML('Candidate');var t1=this._election;default:if(state===2||state===1||state===0&&!(t1==null))switch(state){case 0:this._candidates=t1.get$places().selectMany$1(new $.CondorcetView_updateElement_anon()).toReadOnlyCollection$0();var colors=this._candidates.toHashMap$1(new $.CondorcetView_updateElement_anon0());case 1:state=0;var darkColors=this._candidates.toHashMap$1(new $.CondorcetView_updateElement_anon1());case 2:state=0;for(t1=$.iterator(this._candidates);t1.hasNext$0()===true;){var t2=t1.next$0();cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);cell.set$innerHTML($.toString(t2));t2=$.index(colors,t2);cell.get$style().set$background(t2);cell.set$colSpan(3);}for(var t1=$.iterator(this._election.get$places()),evenCandidateRow=true,evenPlaceRow=true;t1.hasNext$0()===true;){t2=t1.next$0();for(var t3=$.iterator(t2),first=true;t3.hasNext$0()===true;){var t4=t3.next$0();row=table.insertRow$1(-1);var t5=row.get$classes();$.add$1(t5,evenPlaceRow?'row-even':'row-odd');if(first){cell=$._ElementFactoryProvider_Element$tag('th');$.add$1(row.get$elements(),cell);$.add$1(cell.get$classes(),'place-number');cell.set$rowSpan($.get$length(t2));cell.set$innerHTML($.toString(t2.get$place()));first=false;}cell=row.insertCell$1(-1);$.add$1(cell.get$classes(),'candidate-cell');t5=$.index(colors,t4);cell.get$style().set$background(t5);cell.set$innerHTML($.toString(t4));for(t5=$.iterator(this._candidates);t5.hasNext$0()===true;){var t6=t5.next$0();if($.eqB(t6,t4)){cell=row.insertCell$1(-1);cell.get$style().set$background('#999999');cell.set$colSpan(3);}else{var pair=this._election.getPair$2(t4,t6);if($.eqB(t4,pair.get$winner())){var leftColor=$.index(darkColors,t4);var rightColor=$.index(darkColors,t6);var middleText='&gt;';var cellClass='winner';}else if($.eqB(t6,pair.get$winner())){leftColor=$.index(colors,t4);rightColor=$.index(colors,t6);middleText='&lt;';cellClass='loser';}else{leftColor=$.index(darkColors,t4);rightColor=$.index(darkColors,t6);middleText='=';cellClass='tie';}var cellData=this._getPairElementName$2(t4,t6);cell=row.insertCell$1(-1);cell.set$innerHTML($.toString(pair.get$firstOverSecond()));cell.get$style().set$color(leftColor);$.add$1(cell.get$classes(),'vote-count');$.add$1(cell.get$classes(),'pair-cell');$.add$1(cell.get$classes(),cellData);$.add$1(cell.get$classes(),cellClass);$.add$1(cell.get$classes(),'left_value');$.indexSet(cell.get$dataAttributes(),'pair-ids',cellData);var cell0=row.insertCell$1(-1);cell0.set$innerHTML(middleText);$.add$1(cell0.get$classes(),'pair-cell');$.add$1(cell0.get$classes(),cellClass);$.add$1(cell0.get$classes(),cellData);$.indexSet(cell0.get$dataAttributes(),'pair-ids',cellData);var cell1=row.insertCell$1(-1);cell1.set$innerHTML($.toString(pair.get$secondOverFirst()));cell1.get$style().set$color(rightColor);$.add$1(cell1.get$classes(),'vote-count');$.add$1(cell1.get$classes(),'right_value');$.add$1(cell1.get$classes(),cellClass);$.add$1(cell1.get$classes(),'pair-cell');$.add$1(cell1.get$classes(),cellData);$.indexSet(cell1.get$dataAttributes(),'pair-ids',cellData);cell=cell1;}}evenCandidateRow=!evenCandidateRow;}evenPlaceRow=!evenPlaceRow;}}$.add$1(table.get$on().get$mouseMove(),this.get$_onMouseOver());$.add$1(table.get$on().get$mouseOut(),this.get$_onMouseOut());$.add$1(this.get$node().get$elements(),table);}},
 set$_thePair: function(pair){if(!$.eqB(pair,this._hoveringPair)){this._hoveringPair=pair;this._updateCellHoverStyle$0();this._hoverChangedHandle.fireEvent$1($.CTC24);}},
 _updateCellHoverStyle$0: function(){$.forEach(this.get$node().queryAll$1('td.pair-cell.hover-pair'),new $.CondorcetView__updateCellHoverStyle_anon('hover-pair'));var t1=this._hoveringPair;if(!(t1==null)){var matchClass=this._getPairElementName$2(t1.get$Item1(),this._hoveringPair.get$Item2());$.forEach(this.get$node().queryAll$1('td.pair-cell.'+$.S(matchClass)),new $.CondorcetView__updateCellHoverStyle_anon0('hover-pair'));}},
 _onMouseOver$1: function(e){var t1=e.get$toElement();if(typeof t1==='object'&&t1!==null&&t1.is$Element()){var pair=$.CondorcetView__getPair(e.get$toElement());if(!(pair==null)){this.set$_thePair($.Tuple$($.index(this._candidates,pair.get$Item1()),$.index(this._candidates,pair.get$Item2())));return;}}this.set$_thePair(null);},
 get$_onMouseOver: function() { return new $.BoundClosure0(this, '_onMouseOver$1'); },
 _onMouseOut$1: function(args){this.set$_thePair(null);},
 get$_onMouseOut: function() { return new $.BoundClosure0(this, '_onMouseOut$1'); },
 _getPairElementName$2: function(can1,can2){var cIndex=$.indexOf$1(this._candidates,can1);var oIndex=$.indexOf$1(this._candidates,can2);return 'pair'+$.S($.min(cIndex,oIndex))+'_'+$.S($.max(cIndex,oIndex));}
};

$$.CalcEngine = {"":
 ["_distanceElectionMapper", "_pluralityElectionMapper", "_condorcetElectionMapper", "_voterHexMapper", "_hoverPair"],
 "super": "Object",
 get$locationData: function(){return this._distanceElectionMapper.get$input();},
 set$locationData: function(data){$.requireArgumentNotNull(data,'data');this._distanceElectionMapper.set$input(data);},
 candidatesMoved$0: function(){this.set$locationData(this.get$locationData());},
 get$candidatesMoved: function() { return new $.BoundClosure(this, 'candidatesMoved$0'); },
 set$hoverPair: function(pair){this._hoverPair=pair;this._updateVoterHexMapper$0();},
 get$distanceElection: function(){return this._distanceElectionMapper.get$output();},
 get$pluralityElection: function(){return this._pluralityElectionMapper.get$output();},
 get$condorcetElection: function(){return this._condorcetElectionMapper.get$output();},
 get$voterHexMap: function(){return this._voterHexMapper.get$output();},
 addCandidate$0: function(){var newData=this.get$locationData().cloneAndAddCandidate$0();this._distanceElectionMapper.set$input(newData);},
 removeCandidate$1: function(candidate){var newData=this.get$locationData().cloneAndRemove$1(candidate);this._distanceElectionMapper.set$input(newData);},
 get$locationDataChanged: function(){return this._distanceElectionMapper.get$inputChanged();},
 get$distanceElectionChanged: function(){return this._distanceElectionMapper.get$outputChanged();},
 get$pluralityElectionChanged: function(){return this._pluralityElectionMapper.get$outputChanged();},
 get$condorcetElectionChanged: function(){return this._condorcetElectionMapper.get$outputChanged();},
 get$voterHueMapperChanged: function(){return this._voterHexMapper.get$outputChanged();},
 _distanceElectionChanged$0: function(){var t1=this.get$distanceElection().get$ballots();this._pluralityElectionMapper.set$input(t1);t1=this.get$distanceElection().get$ballots();this._condorcetElectionMapper.set$input(t1);this._updateVoterHexMapper$0();},
 _updateVoterHexMapper$0: function(){var val=$.Tuple3$(this.get$distanceElection(),this.get$locationData(),this._hoverPair);this._voterHexMapper.set$input(val);},
 CalcEngine$0: function(){$.add$1(this._distanceElectionMapper.get$outputChanged(),new $.anon0(this));}
};

$$._DistanceElectionMapper = {"":
 ["_sendPort", "_completer", "_innerFuture", "_input", "_future", "_output", "_pending", "_outputChangedHandle", "_inputChangedHandle", "_errorHandle"],
 "super": "SendPortValue"
};

$$._PluralityElectionMapper = {"":
 ["_sendPort", "_completer", "_innerFuture", "_input", "_future", "_output", "_pending", "_outputChangedHandle", "_inputChangedHandle", "_errorHandle"],
 "super": "SendPortValue"
};

$$._CondorcetElectionMapper = {"":
 ["_sendPort", "_completer", "_innerFuture", "_input", "_future", "_output", "_pending", "_outputChangedHandle", "_inputChangedHandle", "_errorHandle"],
 "super": "SendPortValue"
};

$$._VoterHexMapper = {"":
 ["_sendPort", "_completer", "_innerFuture", "_input", "_future", "_output", "_pending", "_outputChangedHandle", "_inputChangedHandle", "_errorHandle"],
 "super": "SendPortValue"
};

$$.FutureValue = {"":
 [],
 "super": "Object",
 get$input: function(){return this._input;},
 set$input: function(value){this._input=value;if(this._future==null)this._startFuture$0();else this._pending=true;this._inputChangedHandle.fireEvent$1($.CTC24);},
 get$output: function(){return this._output;},
 get$outputChanged: function(){return this._outputChangedHandle;},
 get$inputChanged: function(){return this._inputChangedHandle;},
 _startFuture$0: function(){this._future=this.getFuture$1(this._input);this._future.handleException$1(this.get$_futureException());this._future.then$1(this.get$_futureCompleted());},
 _futureException$1: function(exception){this._future=null;this._errorHandle.fireEvent$1(exception);this._cleanup$0();return true;},
 get$_futureException: function() { return new $.BoundClosure0(this, '_futureException$1'); },
 _futureCompleted$1: function(value){this._future=null;this._output=value;this._outputChangedHandle.fireEvent$1($.CTC24);this._cleanup$0();},
 get$_futureCompleted: function() { return new $.BoundClosure0(this, '_futureCompleted$1'); },
 _cleanup$0: function(){if(this._pending===true){this._pending=false;this._startFuture$0();}}
};

$$.FutureValueResult = {"":
 ["value?", "exception?"],
 "super": "Object",
 get$isException: function(){return !(this.exception==null);},
 operator$eq$1: function(other){return !(other==null)&&$.eqB(other.get$value(),this.value)&&$.eqB(other.get$exception(),this.exception);},
 FutureValueResult$fromException$1: function(exception){$.requireArgumentNotNull(this.exception,'exception');}
};

$$.SendPortValue = {"":
 [],
 "super": "FutureValue",
 getFuture$1: function(value){this._completer=$.CompleterImpl$($.getRuntimeTypeInfo(this).TOutput);this._innerFuture=this._sendPort.call$1(value);this._innerFuture.then$1(this.get$__futureCompleted());return this._completer.get$future();},
 __futureCompleted$1: function(value){this._innerFuture=null;if(typeof value==='object'&&value!==null&&value.is$Map()&&$.FutureValueResult_isMyMap(value))this._sendValueResultCompleted$1($.FutureValueResult_FutureValueResult$fromMap(value));else this._lib2_complete$1(value);},
 get$__futureCompleted: function() { return new $.BoundClosure0(this, '__futureCompleted$1'); },
 _sendValueResultCompleted$1: function(value){if(value.get$isException()===true)this._completeException$1(value.get$exception());else this._lib2_complete$1(value.get$value());},
 _lib2_complete$1: function(value){var c=this._completer;this._completer=null;c.complete$1(value);},
 _completeException$1: function(exception){var c=this._completer;this._completer=null;c.completeException$1(exception);}
};

$$._convertDartToNative_PrepareForStructuredClone_findSlot = {"":
 ["copies_3", "values_2"],
 "super": "Closure",
 call$1: function(value){var t1=this.values_2;var length$=t1.length;for(var i=0;i<length$;++i){if(i<0||i>=t1.length)throw $.ioore(i);var t2=t1[i];if(t2==null?value==null:t2===value)return i;}t1.push(value);this.copies_3.push(null);return length$;}
};

$$._convertDartToNative_PrepareForStructuredClone_readSlot = {"":
 ["copies_4"],
 "super": "Closure",
 call$1: function(i){var t1=this.copies_4;if(i!==(i|0))throw $.iae(i);if(i<0||i>=t1.length)throw $.ioore(i);return t1[i];}
};

$$._convertDartToNative_PrepareForStructuredClone_writeSlot = {"":
 ["copies_5"],
 "super": "Closure",
 call$2: function(i,x){var t1=this.copies_5;if(i!==(i|0))throw $.iae(i);if(i<0||i>=t1.length)throw $.ioore(i);t1[i]=x;}
};

$$._convertDartToNative_PrepareForStructuredClone_cleanupSlots = {"":
 [],
 "super": "Closure",
 call$0: function(){}
};

$$._convertDartToNative_PrepareForStructuredClone_walk = {"":
 ["writeSlot_8", "findSlot_7", "readSlot_6"],
 "super": "Closure",
 call$1: function(e){var t1={};if(e==null)return e;if(typeof e==='boolean')return e;if(typeof e==='number')return e;if(typeof e==='string')return e;if(typeof e==='object'&&e!==null&&!!e.is$Date)throw $.$$throw($.CTC2);if(typeof e==='object'&&e!==null&&!!e.is$RegExp)throw $.$$throw($.CTC3);if(typeof e==='object'&&e!==null&&e.is$_FileImpl())return e;if(typeof e==='object'&&e!==null&&e.is$File())throw $.$$throw($.CTC4);if(typeof e==='object'&&e!==null&&e.is$_BlobImpl())return e;if(typeof e==='object'&&e!==null&&e.is$Blob())throw $.$$throw($.CTC5);if(typeof e==='object'&&e!==null&&e.is$_FileListImpl())return e;if(typeof e==='object'&&e!==null&&e.is$FileList())throw $.$$throw($.CTC6);if(typeof e==='object'&&e!==null&&e.is$_ImageDataImpl())return e;if(typeof e==='object'&&e!==null&&e.is$ImageData())throw $.$$throw($.CTC6);if(typeof e==='object'&&e!==null&&e.is$_ArrayBufferImpl())return e;if(typeof e==='object'&&e!==null&&e.is$ArrayBuffer())throw $.$$throw($.CTC7);if(typeof e==='object'&&e!==null&&e.is$_ArrayBufferViewImpl())return e;if(typeof e==='object'&&e!==null&&e.is$ArrayBufferView())throw $.$$throw($.CTC8);if(typeof e==='object'&&e!==null&&e.is$Map()){var slot=this.findSlot_7.call$1(e);t1.copy_1=this.readSlot_6.call$1(slot);var t2=t1.copy_1;if(!(t2==null))return t2;t1.copy_1={};this.writeSlot_8.call$2(slot,t1.copy_1);e.forEach$1(new $._convertDartToNative_PrepareForStructuredClone_walk_anon(this,t1));return t1.copy_1;}if(typeof e==='object'&&e!==null&&(e.constructor===Array||e.is$List())){if(typeof e!=='object'||e===null||(e.constructor!==Array||!!e.immutable$list)&&!e.is$JavaScriptIndexingBehavior())return this.call$1$bailout(1,e,0,0,0,0,0,0);var length$=e.length;slot=this.findSlot_7.call$1(e);t2=this.readSlot_6;var copy=t2.call$1(slot);if(!(copy==null)){if(true===copy){copy=new Array(length$);this.writeSlot_8.call$2(slot,copy);}return copy;}t1=e instanceof Array&&!!!(e.immutable$list);var t3=this.writeSlot_8;if(t1){t3.call$2(slot,true);for(var i=0;i<length$;++i){if(i<0||i>=e.length)throw $.ioore(i);var element=e[i];var elementCopy=this.call$1(element);if(!(elementCopy==null?element==null:elementCopy===element)){copy=t2.call$1(slot);if(true===copy){copy=new Array(length$);t3.call$2(slot,copy);}if(typeof copy!=='object'||copy===null||(copy.constructor!==Array||!!copy.immutable$list)&&!copy.is$JavaScriptIndexingBehavior())return this.call$1$bailout(2,copy,i,t3,e,length$,elementCopy,slot);for(var j=0;j<i;++j){if(j<0||j>=e.length)throw $.ioore(j);t1=e[j];if(j<0||j>=copy.length)throw $.ioore(j);copy[j]=t1;}if(i<0||i>=copy.length)throw $.ioore(i);copy[i]=elementCopy;++i;break;}}if(copy==null){t3.call$2(slot,e);copy=e;}}else{copy=new Array(length$);t3.call$2(slot,copy);i=0;}if(typeof copy!=='object'||copy===null||(copy.constructor!==Array||!!copy.immutable$list)&&!copy.is$JavaScriptIndexingBehavior())return this.call$1$bailout(3,e,copy,length$,i,0,0,0);for(;i<length$;++i){if(i<0||i>=e.length)throw $.ioore(i);t1=this.call$1(e[i]);if(i<0||i>=copy.length)throw $.ioore(i);copy[i]=t1;}return copy;}throw $.$$throw($.CTC9);},
 call$1$bailout: function(state,env0,env1,env2,env3,env4,env5,env6){switch(state){case 1:var e=env0;break;case 2:copy=env0;i=env1;t3=env2;e=env3;length$=env4;elementCopy=env5;slot=env6;break;case 3:e=env0;copy=env1;length$=env2;i=env3;break;}switch(state){case 0:var t1={};if(e==null)return e;if(typeof e==='boolean')return e;if(typeof e==='number')return e;if(typeof e==='string')return e;if(typeof e==='object'&&e!==null&&!!e.is$Date)throw $.$$throw($.CTC2);if(typeof e==='object'&&e!==null&&!!e.is$RegExp)throw $.$$throw($.CTC3);if(typeof e==='object'&&e!==null&&e.is$_FileImpl())return e;if(typeof e==='object'&&e!==null&&e.is$File())throw $.$$throw($.CTC4);if(typeof e==='object'&&e!==null&&e.is$_BlobImpl())return e;if(typeof e==='object'&&e!==null&&e.is$Blob())throw $.$$throw($.CTC5);if(typeof e==='object'&&e!==null&&e.is$_FileListImpl())return e;if(typeof e==='object'&&e!==null&&e.is$FileList())throw $.$$throw($.CTC6);if(typeof e==='object'&&e!==null&&e.is$_ImageDataImpl())return e;if(typeof e==='object'&&e!==null&&e.is$ImageData())throw $.$$throw($.CTC6);if(typeof e==='object'&&e!==null&&e.is$_ArrayBufferImpl())return e;if(typeof e==='object'&&e!==null&&e.is$ArrayBuffer())throw $.$$throw($.CTC7);if(typeof e==='object'&&e!==null&&e.is$_ArrayBufferViewImpl())return e;if(typeof e==='object'&&e!==null&&e.is$ArrayBufferView())throw $.$$throw($.CTC8);if(typeof e==='object'&&e!==null&&e.is$Map()){var slot=this.findSlot_7.call$1(e);t1.copy_1=this.readSlot_6.call$1(slot);var t2=t1.copy_1;if(!(t2==null))return t2;t1.copy_1={};this.writeSlot_8.call$2(slot,t1.copy_1);e.forEach$1(new $._convertDartToNative_PrepareForStructuredClone_walk_anon(this,t1));return t1.copy_1;}default:if(state===3||state===2||state===1||state===0&&typeof e==='object'&&e!==null&&(e.constructor===Array||e.is$List()))switch(state){case 0:case 1:state=0;var length$=$.get$length(e);slot=this.findSlot_7.call$1(e);t2=this.readSlot_6;var copy=t2.call$1(slot);if(!(copy==null)){if(true===copy){copy=new Array(length$);this.writeSlot_8.call$2(slot,copy);}return copy;}t1=e instanceof Array&&!!!(e.immutable$list);var t3=this.writeSlot_8;case 2:if(state===2||state===0&&t1)switch(state){case 0:t3.call$2(slot,true);var i=0;case 2:L0:while(true)switch(state){case 0:if(!$.ltB(i,length$))break L0;var element=$.index(e,i);var elementCopy=this.call$1(element);case 2:if(state===2||state===0&&!(elementCopy==null?element==null:elementCopy===element))switch(state){case 0:copy=t2.call$1(slot);if(true===copy){copy=new Array(length$);t3.call$2(slot,copy);}case 2:state=0;for(var j=0;j<i;++j)$.indexSet(copy,j,$.index(e,j));$.indexSet(copy,i,elementCopy);++i;break L0;}++i;}if(copy==null){t3.call$2(slot,e);copy=e;}}else{copy=new Array(length$);t3.call$2(slot,copy);i=0;}case 3:state=0;for(;$.ltB(i,length$);++i)$.indexSet(copy,i,this.call$1($.index(e,i)));return copy;}throw $.$$throw($.CTC9);}}
};

$$._convertDartToNative_PrepareForStructuredClone_walk_anon = {"":
 ["walk_9", "box_0"],
 "super": "Closure",
 call$2: function(key,value){this.box_0.copy_1[key] = this.walk_9.call$1(value);}
};

$$.Maps__emitMap_anon = {"":
 ["result_3", "box_0", "visiting_2"],
 "super": "Closure",
 call$2: function(k,v){var t1=this.box_0;if(t1.first_1!==true)$.add$1(this.result_3,', ');t1.first_1=false;t1=this.result_3;var t2=this.visiting_2;$.Collections__emitObject(k,t1,t2);$.add$1(t1,': ');$.Collections__emitObject(v,t1,t2);}
};

$$.EventHandle_fireEvent_anon = {"":
 ["args_0"],
 "super": "Closure",
 call$2: function(id,handler){handler.call$1(this.args_0);}
};

$$.invokeClosure_anon = {"":
 ["closure_0"],
 "super": "Closure",
 call$0: function(){return this.closure_0.call$0();}
};

$$.invokeClosure_anon0 = {"":
 ["closure_2", "arg1_1"],
 "super": "Closure",
 call$0: function(){return this.closure_2.call$1(this.arg1_1);}
};

$$.invokeClosure_anon1 = {"":
 ["closure_5", "arg1_4", "arg2_3"],
 "super": "Closure",
 call$0: function(){return this.closure_5.call$2(this.arg1_4,this.arg2_3);}
};

$$.anon1 = {"":
 ["this_0"],
 "super": "Closure",
 call$1: function(data){this.this_0.get$_calcEngine().candidatesMoved$0();}
};

$$.anon2 = {"":
 ["this_1"],
 "super": "Closure",
 call$1: function(args){this.this_1._requestFrame$0();}
};

$$.anon3 = {"":
 ["this_2"],
 "super": "Closure",
 call$1: function(data){this.this_2.get$_calcEngine().removeCandidate$1(data);}
};

$$.anon4 = {"":
 ["this_3"],
 "super": "Closure",
 call$1: function(args){this.this_3.get$_calcEngine().addCandidate$0();}
};

$$.anon5 = {"":
 ["this_4"],
 "super": "Closure",
 call$1: function(args){var t1=this.this_4;var t2=t1.get$_condorcetView().get$hoveringPair();t1.get$_calcEngine().set$hoverPair(t2);var hoverElements=!(t1.get$_condorcetView().get$hoveringPair()==null)?[t1.get$_condorcetView().get$hoveringPair().get$Item1(),t1.get$_condorcetView().get$hoveringPair().get$Item2()]:null;t1.get$_rootMapElement().set$showOnlyPlayers(hoverElements);}
};

$$.anon0 = {"":
 ["this_0"],
 "super": "Closure",
 call$1: function(args){this.this_0._distanceElectionChanged$0();}
};

$$._voterHexMapperIsolate_anon = {"":
 [],
 "super": "Closure",
 call$2: function(tuple,reply){var map=$.HashMapImplementation$('MapPlayer','String');for(var t1=$.iterator(tuple.get$Item1().get$ballots());t1.hasNext$0()===true;){var t2=t1.next$0();var candidate=tuple.get$Item3()==null?t2.get$choice():t2.get$rank().where$1(new $._voterHexMapperIsolate_anon0(tuple)).first$0();if(!(candidate==null)){var hue=$.LocationData_getHue(candidate);map.operator$indexSet$2(t2.get$voter(),$.HslColor_HslColor(hue,0.5,0.75).toRgb$0().toHex$0());}}reply.send$1(map);}
};

$$._voterHexMapperIsolate_anon0 = {"":
 ["tuple_0"],
 "super": "Closure",
 call$1: function(c){var t1=this.tuple_0;return $.eqB(c,t1.get$Item3().get$Item1())||$.eqB(c,t1.get$Item3().get$Item2());}
};

$$.RgbColor_toHex_anon = {"":
 ["buffer_0"],
 "super": "Closure",
 call$1: function(c){$.add$1(this.buffer_0,$.RgbColor__prependZeroIfNecessaryHelper($.toRadixString(c,16)));}
};

$$._IsolateNatives__spawn_anon = {"":
 ["port_1", "completer_0"],
 "super": "Closure",
 call$2: function(msg,replyPort){this.port_1.close$0();this.completer_0.complete$1(replyPort);}
};

$$.anon = {"":
 ["this_0"],
 "super": "Closure",
 call$1: function(p){var t1=this.this_0;t1.set$_port(p);for(var t2=$.iterator(t1.get$pending());t2.hasNext$0()===true;){var t3=t2.next$0();p.send$2($.index(t3,'message'),$.index(t3,'replyTo'));}t1.set$pending(null);}
};

$$.DoubleLinkedQueue_length__ = {"":
 ["box_0"],
 "super": "Closure",
 call$1: function(element){var t1=this.box_0;t1.counter_1=$.add(t1.counter_1,1);}
};

$$._convertNativeToDart_AcceptStructuredClone_findSlot = {"":
 ["copies_1", "values_0"],
 "super": "Closure",
 call$1: function(value){var t1=this.values_0;var length$=t1.length;for(var i=0;i<length$;++i){if(i<0||i>=t1.length)throw $.ioore(i);var t2=t1[i];if(t2==null?value==null:t2===value)return i;}t1.push(value);this.copies_1.push(null);return length$;}
};

$$._convertNativeToDart_AcceptStructuredClone_readSlot = {"":
 ["copies_2"],
 "super": "Closure",
 call$1: function(i){var t1=this.copies_2;if(i!==(i|0))throw $.iae(i);if(i<0||i>=t1.length)throw $.ioore(i);return t1[i];}
};

$$._convertNativeToDart_AcceptStructuredClone_writeSlot = {"":
 ["copies_3"],
 "super": "Closure",
 call$2: function(i,x){var t1=this.copies_3;if(i!==(i|0))throw $.iae(i);if(i<0||i>=t1.length)throw $.ioore(i);t1[i]=x;}
};

$$._convertNativeToDart_AcceptStructuredClone_walk = {"":
 ["writeSlot_6", "findSlot_5", "readSlot_4"],
 "super": "Closure",
 call$1: function(e){if(typeof e!=='object'||e===null||(e.constructor!==Array||!!e.immutable$list)&&!e.is$JavaScriptIndexingBehavior())return this.call$1$bailout(1,e,0,0);if(e instanceof Date)throw $.$$throw($.CTC2);if(e instanceof RegExp)throw $.$$throw($.CTC3);if($._isJavaScriptSimpleObject(e)){var slot=this.findSlot_5.call$1(e);var copy=this.readSlot_4.call$1(slot);if(!(copy==null))return copy;copy=$.makeLiteralMap([]);if(typeof copy!=='object'||copy===null||(copy.constructor!==Array||!!copy.immutable$list)&&!copy.is$JavaScriptIndexingBehavior())return this.call$1$bailout(2,e,slot,copy);this.writeSlot_6.call$2(slot,copy);for(var t1=$.iterator(Object.keys(e));t1.hasNext$0()===true;){var t2=t1.next$0();var t3=this.call$1(e[t2]);if(t2!==(t2|0))throw $.iae(t2);if(t2<0||t2>=copy.length)throw $.ioore(t2);copy[t2]=t3;}return copy;}if(e instanceof Array){slot=this.findSlot_5.call$1(e);copy=this.readSlot_4.call$1(slot);if(!(copy==null))return copy;this.writeSlot_6.call$2(slot,e);var length$=e.length;for(var i=0;i<length$;++i){if(i<0||i>=e.length)throw $.ioore(i);t1=this.call$1(e[i]);if(i<0||i>=e.length)throw $.ioore(i);e[i]=t1;}return e;}return e;},
 call$1$bailout: function(state,env0,env1,env2){switch(state){case 1:var e=env0;break;case 2:e=env0;slot=env1;copy=env2;break;}switch(state){case 0:case 1:state=0;if(e==null)return e;if(typeof e==='boolean')return e;if(typeof e==='number')return e;if(typeof e==='string')return e;if(e instanceof Date)throw $.$$throw($.CTC2);if(e instanceof RegExp)throw $.$$throw($.CTC3);case 2:if(state===2||state===0&&$._isJavaScriptSimpleObject(e))switch(state){case 0:var slot=this.findSlot_5.call$1(e);var copy=this.readSlot_4.call$1(slot);if(!(copy==null))return copy;copy=$.makeLiteralMap([]);case 2:state=0;this.writeSlot_6.call$2(slot,copy);for(var t1=$.iterator(Object.keys(e));t1.hasNext$0()===true;){var t2=t1.next$0();$.indexSet(copy,t2,this.call$1(e[t2]));}return copy;}if(e instanceof Array){slot=this.findSlot_5.call$1(e);copy=this.readSlot_4.call$1(slot);if(!(copy==null))return copy;this.writeSlot_6.call$2(slot,e);var length$=$.get$length(e);for(var i=0;$.ltB(i,length$);++i)$.indexSet(e,i,this.call$1($.index(e,i)));return e;}return e;}}
};

$$.LinkedHashMapImplementation_forEach__ = {"":
 ["f_0"],
 "super": "Closure",
 call$1: function(entry){this.f_0.call$2(entry.get$key(),entry.get$value());}
};

$$._convertNativeToDart_IDBKey_containsDate = {"":
 [],
 "super": "Closure",
 call$1: function(object){if(object instanceof Date)return true;if(typeof object==='object'&&object!==null&&(object.constructor===Array||object.is$List())){if(typeof object!=='object'||object===null||object.constructor!==Array&&!object.is$JavaScriptIndexingBehavior())return this.call$1$bailout(1,object);for(var i=0;t1=object.length,i<t1;++i){if(i<0||i>=t1)throw $.ioore(i);if(this.call$1(object[i])===true)return true;}}return false;var t1;},
 call$1$bailout: function(state,env0){switch(state){case 1:var object=env0;break;}switch(state){case 0:if(object instanceof Date)return true;case 1:if(state===1||state===0&&typeof object==='object'&&object!==null&&(object.constructor===Array||object.is$List()))switch(state){case 0:case 1:state=0;for(var i=0;$.ltB(i,$.get$length(object));++i)if(this.call$1($.index(object,i))===true)return true;}return false;}}
};

$$._BaseSendPort_call_anon = {"":
 ["port_1", "completer_0"],
 "super": "Closure",
 call$2: function(value,ignoreReplyTo){this.port_1.close$0();var t1=typeof value==='object'&&value!==null&&!!value.is$Exception;var t2=this.completer_0;if(t1)t2.completeException$1(value);else t2.complete$1(value);}
};

$$._NativeJsSendPort_send_anon = {"":
 ["this_5", "message_4", "replyTo_3"],
 "super": "Closure",
 call$0: function(){var t1={};var t2=this.this_5;var t3=this.replyTo_3;t2._checkReplyTo$1(t3);var isolate=$.index($._globalState().get$isolates(),t2.get$_isolateId());if(isolate==null)return;if(t2.get$_receivePort().get$_callback()==null)return;var shouldSerialize=!($._globalState().get$currentContext()==null)&&!$.eqB($._globalState().get$currentContext().get$id(),t2.get$_isolateId());var msg=this.message_4;t1.msg_1=msg;t1.reply_2=t3;if(shouldSerialize){t1.msg_1=$._serializeMessage(t1.msg_1);t1.reply_2=$._serializeMessage(t1.reply_2);}$._globalState().get$topEventLoop().enqueue$3(isolate,new $._NativeJsSendPort_send_anon0(t2,t1,shouldSerialize),'receive '+$.S(msg));}
};

$$._NativeJsSendPort_send_anon0 = {"":
 ["this_7", "box_0", "shouldSerialize_6"],
 "super": "Closure",
 call$0: function(){var t1=this.this_7;if(!(t1.get$_receivePort().get$_callback()==null)){if(this.shouldSerialize_6===true){var t2=this.box_0;t2.msg_1=$._deserializeMessage(t2.msg_1);t2.reply_2=$._deserializeMessage(t2.reply_2);}t1=t1.get$_receivePort();t2=this.box_0;t1._callback$2(t2.msg_1,t2.reply_2);}}
};

$$._waitForPendingPorts_anon = {"":
 ["callback_0"],
 "super": "Closure",
 call$1: function(_){return this.callback_0.call$0();}
};

$$._WorkerSendPort_send_anon = {"":
 ["this_2", "message_1", "replyTo_0"],
 "super": "Closure",
 call$0: function(){var t1=this.this_2;var t2=this.replyTo_0;t1._checkReplyTo$1(t2);var workerMessage=$._serializeMessage($.makeLiteralMap(['command','message','port',t1,'msg',this.message_1,'replyTo',t2]));if($._globalState().get$isWorker()===true)$._globalState().get$mainManager().postMessage$1(workerMessage);else $.index($._globalState().get$managers(),t1.get$_workerId()).postMessage$1(workerMessage);}
};

$$._PendingSendPortFinder_visitMap_anon = {"":
 ["this_0"],
 "super": "Closure",
 call$1: function(e){return this.this_0._dispatch$1(e);}
};

$$._StorageImpl_getValues_anon = {"":
 ["values_0"],
 "super": "Closure",
 call$2: function(k,v){return this.values_0.push(v);}
};

$$.HashMapImplementation_getValues__ = {"":
 ["list_2", "box_0"],
 "super": "Closure",
 call$2: function(key,value){var t1=this.list_2;var t2=this.box_0;var t3=t2.i_1;t2.i_1=$.add(t3,1);if(t3!==(t3|0))throw $.iae(t3);if(t3<0||t3>=t1.length)throw $.ioore(t3);t1[t3]=value;}
};

$$.LinkedHashMapImplementation_getValues__ = {"":
 ["list_2", "box_0"],
 "super": "Closure",
 call$1: function(entry){var t1=this.list_2;var t2=this.box_0;var t3=t2.index_1;t2.index_1=$.add(t3,1);t2=entry.get$value();if(t3!==(t3|0))throw $.iae(t3);if(t3<0||t3>=t1.length)throw $.ioore(t3);t1[t3]=t2;}
};

$$._StorageImpl_getKeys_anon = {"":
 ["keys_0"],
 "super": "Closure",
 call$2: function(k,v){return this.keys_0.push(k);}
};

$$.HashMapImplementation_getKeys__ = {"":
 ["list_2", "box_0"],
 "super": "Closure",
 call$2: function(key,value){var t1=this.list_2;var t2=this.box_0;var t3=t2.i_10;t2.i_10=$.add(t3,1);if(t3!==(t3|0))throw $.iae(t3);if(t3<0||t3>=t1.length)throw $.ioore(t3);t1[t3]=key;}
};

$$.LinkedHashMapImplementation_getKeys__ = {"":
 ["list_2", "box_0"],
 "super": "Closure",
 call$1: function(entry){var t1=this.list_2;var t2=this.box_0;var t3=t2.index_10;t2.index_10=$.add(t3,1);t2=entry.get$key();if(t3!==(t3|0))throw $.iae(t3);if(t3<0||t3>=t1.length)throw $.ioore(t3);t1[t3]=t2;}
};

$$._Copier_visitMap_anon = {"":
 ["this_2", "box_0"],
 "super": "Closure",
 call$2: function(key,val){var t1=this.box_0.copy_10;var t2=this.this_2;$.indexSet(t1,t2._dispatch$1(key),t2._dispatch$1(val));}
};

$$._PendingSendPortFinder_visitList_anon = {"":
 ["this_0"],
 "super": "Closure",
 call$1: function(e){return this.this_0._dispatch$1(e);}
};

$$.Futures_wait_anon = {"":
 ["completer_5", "pos_4", "box_0", "result_3", "values_2"],
 "super": "Closure",
 call$1: function(value){var t1=this.values_2;var t2=this.pos_4;if(t2<0||t2>=t1.length)throw $.ioore(t2);t1[t2]=value;t2=this.box_0;var remaining=$.sub(t2.remaining_1,1);t2.remaining_1=remaining;if($.eqB(remaining,0)&&this.result_3.get$isComplete()!==true)this.completer_5.complete$1(t1);}
};

$$.Futures_wait_anon0 = {"":
 ["future_8", "completer_7", "result_6"],
 "super": "Closure",
 call$1: function(exception){if(this.result_6.get$isComplete()!==true)this.completer_7.completeException$2(exception,this.future_8.get$stackTrace());return true;}
};

$$._IsolateNatives__startNonWorker_function = {"":
 ["functionName_1", "replyPort_0"],
 "super": "Closure",
 call$0: function(){$._IsolateNatives__startIsolate($._IsolateNatives__getJSFunctionFromName(this.functionName_1),this.replyPort_0);}
};

$$._IsolateNatives__spawnWorker_anon = {"":
 ["worker_0"],
 "super": "Closure",
 call$1: function(e){$._IsolateNatives__processWorkerMessage(this.worker_0,e);}
};

$$._IsolateNatives__processWorkerMessage_function = {"":
 ["entryPoint_1", "replyTo_0"],
 "super": "Closure",
 call$0: function(){$._IsolateNatives__startIsolate(this.entryPoint_1,this.replyTo_0);}
};

$$._condorcetElectionIsolate_anon = {"":
 [],
 "super": "Closure",
 call$2: function(ballots,reply){reply.send$1($.CondorcetElection_CondorcetElection(ballots));}
};

$$.CondorcetElection_CondorcetElection_anon = {"":
 [],
 "super": "Closure",
 call$1: function(b){return b.get$voter();}
};

$$.CondorcetElection_CondorcetElection_anon0 = {"":
 ["TVoter_1", "TCandidate_0"],
 "super": "Closure",
 call$0: function(){return $.ListImplementation_List(null,'RankedBallot<TVoter, TCandidate>');}
};

$$.CondorcetElection_CondorcetElection_anon1 = {"":
 ["hashSet_2"],
 "super": "Closure",
 call$2: function(k,v){var c=$.CondorcetPair_CondorcetPair(k.get$Item1(),k.get$Item2(),v);$.add$1(this.hashSet_2,c);}
};

$$._TarjanList__TarjanList_anon = {"":
 ["TNode_2", "nodes_1", "map_0"],
 "super": "Closure",
 call$2: function(k,v){var t1=this.map_0;var tKey=t1.putIfAbsent$2(k,new $._TarjanList__TarjanList_anon0(k));var t2=this.nodes_1;var edges=$.HashSetImplementation$('_TarjanNode<TNode>');$.indexSet(t2,tKey,edges);if(!(v==null))for(t2=$.iterator(v);t2.hasNext$0()===true;){var t3=t2.next$0();edges.add$1(t1.putIfAbsent$2(t3,new $._TarjanList__TarjanList_anon1(t3)));}}
};

$$._TarjanList__TarjanList_anon0 = {"":
 ["k_3"],
 "super": "Closure",
 call$0: function(){return $._TarjanNode$(this.k_3);}
};

$$._TarjanList__TarjanList_anon1 = {"":
 ["edge_4"],
 "super": "Closure",
 call$0: function(){return $._TarjanNode$(this.edge_4);}
};

$$.Enumerable_select_anon = {"":
 ["this_1", "f_0"],
 "super": "Closure",
 call$1: function(s){return $._SelectIterator$(s,this.f_0,$.getRuntimeTypeInfo(this.this_1).T,'Object');}
};

$$.Enumerable_where_anon = {"":
 ["this_1", "f_0"],
 "super": "Closure",
 call$1: function(s){return $._WhereIterator$(s,this.f_0,$.getRuntimeTypeInfo(this.this_1).T);}
};

$$.Enumerable_first_anon = {"":
 [],
 "super": "Closure",
 call$1: function(e){return true;}
};

$$.ListBase_iterator_anon = {"":
 ["this_0"],
 "super": "Closure",
 call$1: function(i){return $.index(this.this_0,i);}
};

$$.CondorcetPair_CondorcetPair_anon = {"":
 ["box_0"],
 "super": "Closure",
 call$1: function(b){var t1=b.get$rank();var t2=this.box_0;var firstIndex=$.indexOf$1(t1,t2.can1_1);$.requireArgument($.ge(firstIndex,0),'',null);var secondIndex=$.indexOf$1(b.get$rank(),t2.can2_2);$.requireArgument($.ge(secondIndex,0),'',null);if($.ltB(firstIndex,secondIndex))t2.fos_3=$.add(t2.fos_3,1);else t2.sof_4=$.add(t2.sof_4,1);}
};

$$.HashSetImplementation_forEach__ = {"":
 ["f_0"],
 "super": "Closure",
 call$2: function(key,value){this.f_0.call$1(key);}
};

$$._pluralityElectionIsolate_anon = {"":
 [],
 "super": "Closure",
 call$2: function(ballots,reply){reply.send$1($.PluralityElection_PluralityElection(ballots));}
};

$$.PluralityElection_PluralityElection_anon = {"":
 [],
 "super": "Closure",
 call$1: function(pb){return pb.get$voter();}
};

$$.PluralityElection_PluralityElection_anon0 = {"":
 [],
 "super": "Closure",
 call$1: function(pb){return pb.get$choice();}
};

$$.PluralityElection_PluralityElection_anon1 = {"":
 ["TCandidate_1", "voteCounts_0"],
 "super": "Closure",
 call$2: function(c,b){var count=$.get$length(b);$.add$1(this.voteCounts_0.putIfAbsent$2(count,new $.PluralityElection_PluralityElection_anon3(this.TCandidate_1)),c);}
};

$$.PluralityElection_PluralityElection_anon3 = {"":
 ["TCandidate_2"],
 "super": "Closure",
 call$0: function(){return $.ListImplementation_List(null,this.TCandidate_2);}
};

$$.PluralityElection_PluralityElection_anon2 = {"":
 [],
 "super": "Closure",
 call$2: function(a,b){return $.compareTo(b,a);}
};

$$.Grouping_Grouping_anon = {"":
 [],
 "super": "Closure",
 call$1: function(v){return v;}
};

$$.Grouping_Grouping_anon0 = {"":
 ["V_0"],
 "super": "Closure",
 call$0: function(){return $.ListImplementation_List(null,this.V_0);}
};

$$.NoneHashMap_getKeys_anon = {"":
 [],
 "super": "Closure",
 call$1: function(t){return t.get$Item1();}
};

$$.NoneHashMap_getValues_anon = {"":
 [],
 "super": "Closure",
 call$1: function(t){return t.get$Item2();}
};

$$._distanceElectionIsolate_anon = {"":
 [],
 "super": "Closure",
 call$2: function(data,reply){reply.send$1($.DistanceElection_DistanceElection$fromData(data));}
};

$$.DistanceElection_DistanceElection_anon = {"":
 ["cans_2"],
 "super": "Closure",
 call$1: function(voter){return $.DistanceBallot_DistanceBallot(voter,this.cans_2,'MapPlayer','MapPlayer');}
};

$$.DistanceElection_DistanceElection_anon0 = {"":
 ["ballots_3"],
 "super": "Closure",
 call$1: function(candidate){for(var t1=$.iterator(this.ballots_3),sumOfSquaredDistance=0,count=0,sumOfDistance=0;t1.hasNext$0()===true;){var distance=t1.next$0().getDistance$1(candidate);if(typeof distance!=='number')throw $.iae(distance);sumOfDistance+=distance;sumOfSquaredDistance+=distance*distance;++count;}return $.Tuple$(sumOfDistance/count,sumOfSquaredDistance/count,'num','num');}
};

$$.DistanceElection_DistanceElection_anon1 = {"":
 [],
 "super": "Closure",
 call$2: function(a,b){return $.compareTo(a.get$Item1(),b.get$Item1());}
};

$$.DistanceElection_DistanceElection_anon2 = {"":
 ["box_0", "distanceGroups_4"],
 "super": "Closure",
 call$1: function(d){var placeCans=$.index(this.distanceGroups_4,d);var t1=this.box_0;var place=$.DistanceElectionPlace$(t1.placeNumber_1,placeCans,d.get$Item1(),d.get$Item2());t1.placeNumber_1=$.add(t1.placeNumber_1,$.get$length(placeCans));return place;}
};

$$.DistanceBallot_DistanceBallot_anon = {"":
 ["voter_0"],
 "super": "Closure",
 call$1: function(c){return $.div($.toInt($.mul(this.voter_0.get$location().getDistance$1(c.get$location()),128)),128);}
};

$$.DistanceBallot_DistanceBallot_anon0 = {"":
 ["distances_1"],
 "super": "Closure",
 call$2: function(a,b){var t1=this.distances_1;var d=$.compareTo($.index(t1,a),$.index(t1,b));if($.eqB(d,0))d=$.rnd().nextBool$0()===true?-1:1;return d;}
};

$$.Enumerable_toHashMap_anon = {"":
 [],
 "super": "Closure",
 call$1: function(a){return a;}
};

$$.Enumerable_toHashMap_anon0 = {"":
 ["box_0", "valueFunc_3", "e_2"],
 "super": "Closure",
 call$0: function(){this.box_0.duplicate_1=false;return this.valueFunc_3.call$1(this.e_2);}
};

$$.LocationData_LocationData$random_anon = {"":
 [],
 "super": "Closure",
 call$1: function(c){return c.scale$1(20);}
};

$$.LocationData_LocationData$random_anon0 = {"":
 ["candidates_0"],
 "super": "Closure",
 call$2: function(c,i){var candidate=$.MapPlayer$(c,$.LocationData_getCandidateName(i));this.candidates_0.push(candidate);}
};

$$.Mouse_markMouseOver_anon = {"":
 [],
 "super": "Closure",
 call$1: function(e){$.CTC28.clear$1(e);$.CTC26.clear$1(e);}
};

$$.Mouse_markMouseOver_anon0 = {"":
 [],
 "super": "Closure",
 call$1: function(e){$.CTC28.set$2(e,true);}
};

$$.AffineTransform_toString_anon = {"":
 [],
 "super": "Closure",
 call$1: function(n){return $.toString(n);}
};

$$.RootMapElement_dragCandidate_anon = {"":
 ["candidate_0"],
 "super": "Closure",
 call$1: function(mp){return $.eq(mp,this.candidate_0);}
};

$$.Enumerable_single_anon = {"":
 [],
 "super": "Closure",
 call$1: function(e){return true;}
};

$$.LocationData_cloneAndRemove_anon = {"":
 ["mp_0"],
 "super": "Closure",
 call$1: function(e){return !$.eqB(e,this.mp_0);}
};

$$.ElementParentImpl_drawOverride_anon = {"":
 ["ctx_0"],
 "super": "Closure",
 call$1: function(e){return e.drawCore$1(this.ctx_0);}
};

$$._ElementImpl_rect_anon = {"":
 ["this_0"],
 "super": "Closure",
 call$0: function(){return $._ElementRectImpl$(this.this_0);}
};

$$._maybeScheduleMeasurementFrame_anon = {"":
 [],
 "super": "Closure",
 call$1: function(e){return $._completeMeasurementFutures();}
};

$$._DocumentFragmentImpl_rect_anon = {"":
 [],
 "super": "Closure",
 call$0: function(){return $.CTC32;}
};

$$.RootMapElement_update_anon = {"":
 ["this_0"],
 "super": "Closure",
 call$1: function(m){var t1=this.this_0;m.set$_radius(t1.get$_radius());m.setTransform$1(t1.get$_tx());}
};

$$.ElementParentImpl_update_anon = {"":
 [],
 "super": "Closure",
 call$1: function(e){return e.update$0();}
};

$$.HashSetImplementation_addAll__ = {"":
 ["this_0"],
 "super": "Closure",
 call$1: function(value){this.this_0.add$1(value);}
};

$$._CssClassSet_add_anon = {"":
 ["value_0"],
 "super": "Closure",
 call$1: function(s){return $.add$1(s,this.value_0);}
};

$$._CssClassSet_addAll_anon = {"":
 ["collection_0"],
 "super": "Closure",
 call$1: function(s){return $.addAll(s,this.collection_0);}
};

$$._CssClassSet_clear_anon = {"":
 [],
 "super": "Closure",
 call$1: function(s){return $.clear(s);}
};

$$.ConstantMap_forEach_anon = {"":
 ["this_1", "f_0"],
 "super": "Closure",
 call$1: function(key){return this.f_0.call$2(key,$.index(this.this_1,key));}
};

$$.ConstantMap_getValues_anon = {"":
 ["this_1", "result_0"],
 "super": "Closure",
 call$1: function(key){return this.result_0.push($.index(this.this_1,key));}
};

$$.FilteredElementList__filtered_anon = {"":
 [],
 "super": "Closure",
 call$1: function(n){return typeof n==='object'&&n!==null&&n.is$Element();}
};

$$.HashSetImplementation_filter__ = {"":
 ["f_1", "result_0"],
 "super": "Closure",
 call$2: function(key,value){if(this.f_1.call$1(key)===true)$.add$1(this.result_0,key);}
};

$$._ChildrenElementList_filter_anon = {"":
 ["f_1", "output_0"],
 "super": "Closure",
 call$1: function(element){if(this.f_1.call$1(element)===true)this.output_0.push(element);}
};

$$.FilteredElementList_removeRange_anon = {"":
 [],
 "super": "Closure",
 call$1: function(el){return el.remove$0();}
};

$$.CondorcetView_updateElement_anon = {"":
 [],
 "super": "Closure",
 call$1: function(p){return p;}
};

$$.CondorcetView_updateElement_anon0 = {"":
 [],
 "super": "Closure",
 call$1: function(c){var hue=$.LocationData_getHue(c);if(hue==null)return '#999999';else return $.HslColor_HslColor(hue,1,0.75).toRgb$0().toHex$0();}
};

$$.CondorcetView_updateElement_anon1 = {"":
 [],
 "super": "Closure",
 call$1: function(c){var hue=$.LocationData_getHue(c);if(hue==null)return '#999999';else return $.HslColor_HslColor(hue,1,0.3).toRgb$0().toHex$0();}
};

$$.CondorcetView__updateCellHoverStyle_anon = {"":
 ["hoverPairClass_0"],
 "super": "Closure",
 call$1: function(e){e.get$classes().remove$1(this.hoverPairClass_0);}
};

$$.CondorcetView__updateCellHoverStyle_anon0 = {"":
 ["hoverPairClass_1"],
 "super": "Closure",
 call$1: function(e){$.add$1(e.get$classes(),this.hoverPairClass_1);}
};

$$.CondorcetView__getPair_anon = {"":
 [],
 "super": "Closure",
 call$1: function(s){return $.parseInt(s);}
};

$$._DataAttributeMap_getKeys_anon = {"":
 ["this_1", "keys_0"],
 "super": "Closure",
 call$2: function(key,value){var t1=this.this_1;if(t1._matches$1(key)===true)this.keys_0.push(t1._strip$1(key));}
};

$$._DataAttributeMap_forEach_anon = {"":
 ["this_1", "f_0"],
 "super": "Closure",
 call$2: function(key,value){var t1=this.this_1;if(t1._matches$1(key)===true)this.f_0.call$2(t1._strip$1(key),value);}
};

$$._DataAttributeMap_getValues_anon = {"":
 ["this_1", "values_0"],
 "super": "Closure",
 call$2: function(key,value){if(this.this_1._matches$1(key)===true)this.values_0.push(value);}
};

$$.CondorcetElection_getPair_anon = {"":
 ["c1_1", "c2_0"],
 "super": "Closure",
 call$1: function(p){return p.matches$2(this.c1_1,this.c2_0);}
};

$$.Enumerable_selectMany_anon = {"":
 ["f_0"],
 "super": "Closure",
 call$1: function(s){return $._SelectManyIterator$_internal(s,this.f_0);}
};

$$.CandidateManagerView__removeCandidateWithId_anon = {"":
 ["id_0"],
 "super": "Closure",
 call$1: function(mp){return $.eq(mp.get$id(),this.id_0);}
};

$$.startRootIsolate_anon = {"":
 [],
 "super": "Closure",
 call$0: function(){$._TimerFactory__factory=$._timerFactory;return;}
};

$$._EventLoop__runHelper_next = {"":
 ["this_0"],
 "super": "Closure",
 call$0: function(){if(this.this_0.runIteration$0()!==true)return;$._window().setTimeout$2(this,0);}
};

$$.anon6 = {"":
 ["this_1", "callback_0"],
 "super": "Closure",
 call$0: function(){return this.callback_0.call$1(this.this_1);}
};

$$.anon7 = {"":
 ["this_1", "callback_0"],
 "super": "Closure",
 call$0: function(){return this.callback_0.call$1(this.this_1);}
};

$$.BoundClosure = {'':
 ['self', 'target'],
 'super': 'Closure',
call$0: function() { return this.self[this.target](); }
};
$$.BoundClosure0 = {'':
 ['self', 'target'],
 'super': 'Closure',
call$1: function(p0) { return this.self[this.target](p0); }
};
$$.BoundClosure1 = {'':
 ['self', 'target'],
 'super': 'Closure',
call$1: function(p0) { return this.self[this.target](p0); },
 call$0: function() {
  return this.call$1(null)
}
};
$$.BoundClosure2 = {'':
 ['self', 'target'],
 'super': 'Closure',
call$2: function(p0, p1) { return this.self[this.target](p0, p1); }
};
$.div$slow = function(a,b){if($.checkNumbers(a,b))return a / b;return a.operator$div$1(b);};

$._InputElementEventsImpl$ = function(_ptr){return new $._InputElementEventsImpl(_ptr);};

$._NativeJsSendPort$ = function(_receivePort,isolateId){return new $._NativeJsSendPort(_receivePort,isolateId);};

$.eqB = function(a,b){if(a == null)return b == null;if(b == null)return false;if(typeof a === "object")if(!!a.operator$eq$1)return a.operator$eq$1(b)===true;return a === b;};

$.set$length = function(receiver,newLength){if($.isJsArray(receiver)){$.checkNull(newLength);if(!(typeof newLength==='number'&&Math.floor(newLength) === newLength))throw $.$$throw($.IllegalArgumentException$(newLength));if(newLength<0)throw $.$$throw($.IndexOutOfRangeException$(newLength));$.checkGrowable(receiver,'set length');receiver.length = newLength;}else receiver.set$length(newLength);return newLength;};

$._Device_userAgent = function(){return $.window().get$navigator().get$userAgent();};

$.checkNum = function(value){if(!(typeof value==='number')){$.checkNull(value);throw $.$$throw($.IllegalArgumentException$(value));}return value;};

$._TextTrackListEventsImpl$ = function(_ptr){return new $._TextTrackListEventsImpl(_ptr);};

$.StackTrace$ = function(stack){return new $.StackTrace(stack);};

$._MediaStreamTrackEventsImpl$ = function(_ptr){return new $._MediaStreamTrackEventsImpl(_ptr);};

$._JsVisitedMap$ = function(){return new $._JsVisitedMap(null);};

$.isJsArray = function(value){return !(value==null)&&value.constructor === Array;};

$._fillStatics = function(context){  $globals = context.isolateStatics;
  $static_init();
};

$.ListIterator$ = function(list,T){var t1=new $.ListIterator(0,list);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$._JavaScriptAudioNodeEventsImpl$ = function(_ptr){return new $._JavaScriptAudioNodeEventsImpl(_ptr);};

$.Size$ = function(width,height){return new $.Size(width,height);};

$._IDBTransactionEventsImpl$ = function(_ptr){return new $._IDBTransactionEventsImpl(_ptr);};

$.DualPivotQuicksort__dualPivotQuicksort = function(a,left,right,compare){if(typeof a!=='object'||a===null||(a.constructor!==Array||!!a.immutable$list)&&!a.is$JavaScriptIndexingBehavior())return $.DualPivotQuicksort__dualPivotQuicksort$bailout(1,a,left,right,compare,0,0,0,0,0,0,0,0,0,0);var sixth=$.tdiv($.add($.sub(right,left),1),6);if(typeof sixth!=='number')throw $.iae(sixth);var index1=left+sixth;var index5=$.sub(right,sixth);if(typeof right!=='number')throw $.iae(right);var index3=$.tdiv(left+right,2);var index2=index3-sixth;var index4=index3+sixth;if(index1!==(index1|0))throw $.iae(index1);var t1=a.length;if(index1<0||index1>=t1)throw $.ioore(index1);var el1=a[index1];if(index2!==(index2|0))throw $.iae(index2);if(index2<0||index2>=t1)throw $.ioore(index2);var el2=a[index2];if(index3!==(index3|0))throw $.iae(index3);if(index3<0||index3>=t1)throw $.ioore(index3);var el3=a[index3];if(index4!==(index4|0))throw $.iae(index4);if(index4<0||index4>=t1)throw $.ioore(index4);var el4=a[index4];if(index5!==(index5|0))throw $.iae(index5);if(index5<0||index5>=t1)throw $.ioore(index5);var el5=a[index5];if($.gtB(compare.call$2(el1,el2),0)){var t0=el1;el1=el2;el2=t0;}if($.gtB(compare.call$2(el4,el5),0)){t0=el5;el5=el4;el4=t0;}if($.gtB(compare.call$2(el1,el3),0)){t0=el3;el3=el1;el1=t0;}if($.gtB(compare.call$2(el2,el3),0)){t0=el3;el3=el2;el2=t0;}if($.gtB(compare.call$2(el1,el4),0)){t0=el1;el1=el4;el4=t0;}if($.gtB(compare.call$2(el3,el4),0)){t0=el3;el3=el4;el4=t0;}if($.gtB(compare.call$2(el2,el5),0)){t0=el5;el5=el2;el2=t0;}if($.gtB(compare.call$2(el2,el3),0)){t0=el3;el3=el2;el2=t0;}if($.gtB(compare.call$2(el4,el5),0)){t0=el5;el5=el4;el4=t0;}if(index1<0||index1>=a.length)throw $.ioore(index1);a[index1]=el1;if(index3<0||index3>=a.length)throw $.ioore(index3);a[index3]=el3;if(index5<0||index5>=a.length)throw $.ioore(index5);a[index5]=el5;if(left!==(left|0))throw $.iae(left);t1=a.length;if(left<0||left>=t1)throw $.ioore(left);var t2=a[left];if(index2<0||index2>=t1)throw $.ioore(index2);a[index2]=t2;if(right!==(right|0))throw $.iae(right);t2=a.length;if(right<0||right>=t2)throw $.ioore(right);var t3=a[right];if(index4<0||index4>=t2)throw $.ioore(index4);a[index4]=t3;var less=left+1;var great=right-1;var pivots_are_equal=$.eqB(compare.call$2(el2,el4),0);if(pivots_are_equal)for(var k=less;k<=great;++k){if(k!==(k|0))throw $.iae(k);if(k<0||k>=a.length)throw $.ioore(k);var ak=a[k];var comp=compare.call$2(ak,el2);if(typeof comp!=='number')return $.DualPivotQuicksort__dualPivotQuicksort$bailout(2,a,left,compare,less,k,index1,index5,el2,pivots_are_equal,right,ak,comp,el4,great);if(comp===0)continue;if(comp<0){if(!(k===less)){if(less!==(less|0))throw $.iae(less);t1=a.length;if(less<0||less>=t1)throw $.ioore(less);t2=a[less];if(k<0||k>=t1)throw $.ioore(k);a[k]=t2;if(less<0||less>=a.length)throw $.ioore(less);a[less]=ak;}++less;}else for(var less0=less+1;true;){if(great!==(great|0))throw $.iae(great);if(great<0||great>=a.length)throw $.ioore(great);comp=compare.call$2(a[great],el2);if($.gtB(comp,0)){--great;continue;}else{t1=$.ltB(comp,0);var great0=great-1;t2=a.length;if(t1){if(less!==(less|0))throw $.iae(less);if(less<0||less>=t2)throw $.ioore(less);t1=a[less];if(k<0||k>=t2)throw $.ioore(k);a[k]=t1;t1=a.length;if(great<0||great>=t1)throw $.ioore(great);t3=a[great];if(less<0||less>=t1)throw $.ioore(less);a[less]=t3;if(great<0||great>=a.length)throw $.ioore(great);a[great]=ak;great=great0;less=less0;break;}else{if(great<0||great>=t2)throw $.ioore(great);t1=a[great];if(k<0||k>=t2)throw $.ioore(k);a[k]=t1;if(great<0||great>=a.length)throw $.ioore(great);a[great]=ak;great=great0;break;}}}}else for(k=less;k<=great;++k){if(k!==(k|0))throw $.iae(k);if(k<0||k>=a.length)throw $.ioore(k);ak=a[k];if($.ltB(compare.call$2(ak,el2),0)){if(!(k===less)){if(less!==(less|0))throw $.iae(less);t1=a.length;if(less<0||less>=t1)throw $.ioore(less);t2=a[less];if(k<0||k>=t1)throw $.ioore(k);a[k]=t2;if(less<0||less>=a.length)throw $.ioore(less);a[less]=ak;}++less;}else if($.gtB(compare.call$2(ak,el4),0))for(less0=less+1;true;){if(great!==(great|0))throw $.iae(great);if(great<0||great>=a.length)throw $.ioore(great);if($.gtB(compare.call$2(a[great],el4),0)){--great;if(great<k)break;continue;}else{if(great<0||great>=a.length)throw $.ioore(great);t1=$.ltB(compare.call$2(a[great],el2),0);great0=great-1;t2=a.length;if(t1){if(less!==(less|0))throw $.iae(less);if(less<0||less>=t2)throw $.ioore(less);t1=a[less];if(k<0||k>=t2)throw $.ioore(k);a[k]=t1;t1=a.length;if(great<0||great>=t1)throw $.ioore(great);t3=a[great];if(less<0||less>=t1)throw $.ioore(less);a[less]=t3;if(great<0||great>=a.length)throw $.ioore(great);a[great]=ak;great=great0;less=less0;}else{if(great<0||great>=t2)throw $.ioore(great);t1=a[great];if(k<0||k>=t2)throw $.ioore(k);a[k]=t1;if(great<0||great>=a.length)throw $.ioore(great);a[great]=ak;great=great0;}break;}}}t1=less-1;if(t1!==(t1|0))throw $.iae(t1);t2=a.length;if(t1<0||t1>=t2)throw $.ioore(t1);t3=a[t1];if(left<0||left>=t2)throw $.ioore(left);a[left]=t3;if(t1<0||t1>=a.length)throw $.ioore(t1);a[t1]=el2;t1=great+1;if(t1!==(t1|0))throw $.iae(t1);t3=a.length;if(t1<0||t1>=t3)throw $.ioore(t1);var t4=a[t1];if(right<0||right>=t3)throw $.ioore(right);a[right]=t4;if(t1<0||t1>=a.length)throw $.ioore(t1);a[t1]=el4;$.DualPivotQuicksort__doSort(a,left,less-2,compare);$.DualPivotQuicksort__doSort(a,great+2,right,compare);if(pivots_are_equal)return;if(less<index1&&great>index5){while(true){if(less!==(less|0))throw $.iae(less);if(less<0||less>=a.length)throw $.ioore(less);if(!$.eqB(compare.call$2(a[less],el2),0))break;++less;}while(true){if(great!==(great|0))throw $.iae(great);if(great<0||great>=a.length)throw $.ioore(great);if(!$.eqB(compare.call$2(a[great],el4),0))break;--great;}for(k=less;k<=great;++k){if(k!==(k|0))throw $.iae(k);if(k<0||k>=a.length)throw $.ioore(k);ak=a[k];if($.eqB(compare.call$2(ak,el2),0)){if(!(k===less)){if(less!==(less|0))throw $.iae(less);t1=a.length;if(less<0||less>=t1)throw $.ioore(less);t2=a[less];if(k<0||k>=t1)throw $.ioore(k);a[k]=t2;if(less<0||less>=a.length)throw $.ioore(less);a[less]=ak;}++less;}else if($.eqB(compare.call$2(ak,el4),0))for(less0=less+1;true;){if(great!==(great|0))throw $.iae(great);if(great<0||great>=a.length)throw $.ioore(great);if($.eqB(compare.call$2(a[great],el4),0)){--great;if(great<k)break;continue;}else{if(great<0||great>=a.length)throw $.ioore(great);t1=$.ltB(compare.call$2(a[great],el2),0);great0=great-1;t2=a.length;if(t1){if(less!==(less|0))throw $.iae(less);if(less<0||less>=t2)throw $.ioore(less);t1=a[less];if(k<0||k>=t2)throw $.ioore(k);a[k]=t1;t1=a.length;if(great<0||great>=t1)throw $.ioore(great);t3=a[great];if(less<0||less>=t1)throw $.ioore(less);a[less]=t3;if(great<0||great>=a.length)throw $.ioore(great);a[great]=ak;great=great0;less=less0;}else{if(great<0||great>=t2)throw $.ioore(great);t1=a[great];if(k<0||k>=t2)throw $.ioore(k);a[k]=t1;if(great<0||great>=a.length)throw $.ioore(great);a[great]=ak;great=great0;}break;}}}$.DualPivotQuicksort__doSort(a,less,great,compare);}else $.DualPivotQuicksort__doSort(a,less,great,compare);};

$.DistanceBallot$_internal = function(voter,items,_distances,TVoter,TCandidate){var t1=new $.DistanceBallot(_distances,items,$.index(items,0),voter);$.setRuntimeTypeInfo(t1,{ 'TVoter': TVoter, 'TCandidate': TCandidate });return t1;};

$.dynamicFunction = function(name$){var f=Object.prototype[name$];if(!(f==null)&&!!f.methods)return f.methods;var methods={};var dartMethod=Object.getPrototypeOf($.CTC42)[name$];if(!(dartMethod==null))$.propertySet(methods,'Object',dartMethod);var bind=function() {return $.dynamicBind.call$4(this, name$, methods, Array.prototype.slice.call(arguments));};bind.methods = methods;$.defineProperty(Object.prototype,name$,bind);return methods;};

$.buildDynamicMetadata = function(inputTable){var result=[];for(var i=0;i<inputTable.length;++i){var tag=inputTable[i][0];var array=inputTable[i];var tags=array[1];var set={};var tagNames=tags.split('|');for(var j=0,index=1;j<tagNames.length;++j){$.propertySet(set,tagNames[j],true);index=j;array=tagNames;}result.push($.MetaInfo$(tag,tags,set));}return result;};

$.ListImplementation_List$from = function(other,E){var result=$.ListImplementation_List(null);for(var t1=$.iterator(other);t1.hasNext$0()===true;)result.push(t1.next$0());return result;};

$._Timer$repeating = function(milliSeconds,callback){var t1=new $._Timer(false,null);t1._Timer$repeating$2(milliSeconds,callback);return t1;};

$.DistanceElection_DistanceElection$fromData = function(data,TVoter,TCandidate){return $.DistanceElection_DistanceElection(data.get$voters(),data.get$candidates());};

$._EventSourceEventsImpl$ = function(_ptr){return new $._EventSourceEventsImpl(_ptr);};

$.Arrays_lastIndexOf = function(a,element,startIndex){if(typeof a!=='string'&&(typeof a!=='object'||a===null||a.constructor!==Array&&!a.is$JavaScriptIndexingBehavior()))return $.Arrays_lastIndexOf$bailout(1,a,element,startIndex);if(typeof startIndex!=='number')return $.Arrays_lastIndexOf$bailout(1,a,element,startIndex);if(startIndex<0)return -1;var t1=a.length;if(startIndex>=t1)startIndex=t1-1;for(var i=startIndex;i>=0;--i){if(i!==(i|0))throw $.iae(i);if(i<0||i>=a.length)throw $.ioore(i);if($.eqB(a[i],element))return i;}return -1;};

$._convertDartToNative_PrepareForStructuredClone = function(value){var values=[];var copies=[];var t1=new $._convertDartToNative_PrepareForStructuredClone_findSlot(copies,values);var t2=new $._convertDartToNative_PrepareForStructuredClone_readSlot(copies);var t3=new $._convertDartToNative_PrepareForStructuredClone_writeSlot(copies);var t4=new $._convertDartToNative_PrepareForStructuredClone_cleanupSlots();var copy=new $._convertDartToNative_PrepareForStructuredClone_walk(t3,t1,t2).call$1(value);t4.call$0();return copy;};

$.floor = function(receiver){return Math.floor(receiver);};

$._JsCopier$ = function(){var t1=new $._JsCopier($._MessageTraverserVisitedMap$());t1._JsCopier$0();return t1;};

$._WebSocketEventsImpl$ = function(_ptr){return new $._WebSocketEventsImpl(_ptr);};

$.shr = function(a,b){if($.checkNumbers(a,b)){if(b<0)throw $.$$throw($.IllegalArgumentException$(b));if(a>0){if(b > 31)return 0;return a >>> b;}if(b>31)b=31;return (a >> b) >>> 0;}return a.operator$shr$1(b);};

$._convertDartToNative_SerializedScriptValue = function(value){return $._convertDartToNative_PrepareForStructuredClone(value);};

$._deserializeMessage = function(message){if($._globalState().get$needSerialization()===true)return $._JsDeserializer$().deserialize$1(message);else return message;};

$.and = function(a,b){if($.checkNumbers(a,b))return (a & b) >>> 0;return a.operator$and$1(b);};

$.Tuple3$ = function(param1,param2,Item3,T1,T2,T3){var t1=new $.Tuple3(Item3,param1,param2);$.setRuntimeTypeInfo(t1,{ 'T1': T1, 'T2': T2, 'T3': T3 });return t1;};

$._MediaStreamEventsImpl$ = function(_ptr){return new $._MediaStreamEventsImpl(_ptr);};

$.setRuntimeTypeInfo = function(target,typeInfo){if(!(target==null))target.builtin$typeInfo = typeInfo;};

$.hashCode = function(receiver){if(typeof receiver==='number')return receiver & 0x1FFFFFFF;if(!(typeof receiver==='string'))return receiver.hashCode$0();var length$=receiver.length;for(var hash=0,i=0;i<length$;++i){var hash0=536870911&hash+receiver.charCodeAt(i);var hash1=536870911&hash0+524287&hash0 << 10;hash1=(hash1^$.shr(hash1,6))>>>0;hash=hash1;}hash0=536870911&hash+67108863&hash << 3;hash0=(hash0^$.shr(hash0,11))>>>0;return 536870911&hash0+16383&hash0 << 15;};

$.FutureImpl_FutureImpl$immediate = function(value,T){var res=$.FutureImpl$();res._setValue$1(value);return res;};

$.mul$slow = function(a,b){if($.checkNumbers(a,b))return a * b;return a.operator$mul$1(b);};

$._waitForPendingPorts = function(message,callback){var finder=$._PendingSendPortFinder$();finder.traverse$1(message);$.Futures_wait(finder.ports).then$1(new $._waitForPendingPorts_anon(callback));};

$.CalcEngine$ = function(){var t1=new $.CalcEngine($._DistanceElectionMapper$(),$._PluralityElectionMapper$(),$._CondorcetElectionMapper$(),$._VoterHexMapper$(),null);t1.CalcEngine$0();return t1;};

$._SimpleEnumerable$ = function(_source,T){var t1=new $._SimpleEnumerable(_source);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$._condorcetElectionIsolate = function(){$.port().receive$1(new $._condorcetElectionIsolate_anon());};

$.getTypeNameOf = function(obj){if($._getTypeNameOf==null)$._getTypeNameOf=$.getFunctionForTypeNameOf();return $._getTypeNameOf.call$1(obj);};

$.RgbColor_RgbColor = function(r,g,b){$.RgbColor__validateComponent(r,'r');$.RgbColor__validateComponent(g,'g');$.RgbColor__validateComponent(b,'b');return $.RgbColor$_internal(r,g,b);};

$.contains$1 = function(receiver,other){return $.contains$2(receiver,other,0);};

$.isValidNumber = function(value){return !(value==null)&&$.isInfinite(value)!==true&&$.isNaN(value)!==true;};

$._IsolateNatives__processWorkerMessage = function(sender,e){var msg=$._deserializeMessage($._IsolateNatives__getEventData(e));switch($.index(msg,'command')){case 'start':var t1=$.index(msg,'id');$._globalState().set$currentManagerId(t1);var entryPoint=$._IsolateNatives__getJSFunctionFromName($.index(msg,'functionName'));var replyTo=$._deserializeMessage($.index(msg,'replyTo'));$._globalState().get$topEventLoop().enqueue$3($._IsolateContext$(),new $._IsolateNatives__processWorkerMessage_function(entryPoint,replyTo),'worker-start');$._globalState().get$topEventLoop().run$0();break;case 'spawn-worker':$._IsolateNatives__spawnWorker($.index(msg,'functionName'),$.index(msg,'uri'),$.index(msg,'replyPort'));break;case 'message':$.index(msg,'port').send$2($.index(msg,'msg'),$.index(msg,'replyTo'));$._globalState().get$topEventLoop().run$0();break;case 'close':$._IsolateNatives__log('Closing Worker');$._globalState().get$managers().remove$1(sender.get$id());sender.terminate$0();$._globalState().get$topEventLoop().run$0();break;case 'log':$._IsolateNatives__log($.index(msg,'msg'));break;case 'print':if($._globalState().get$isWorker()===true)$._globalState().get$mainManager().postMessage$1($._serializeMessage($.makeLiteralMap(['command','print','msg',msg])));else $.print($.index(msg,'msg'));break;case 'error':throw $.$$throw($.index(msg,'msg'));}};

$._EventsImpl$ = function(_ptr){return new $._EventsImpl(_ptr);};

$._RTCPeerConnectionEventsImpl$ = function(_ptr){return new $._RTCPeerConnectionEventsImpl(_ptr);};

$.neg = function(a){if(typeof a === "number")return -a;return a.negate$0();};

$.HashSetImplementation$ = function(E){var t1=new $.HashSetImplementation(null);$.setRuntimeTypeInfo(t1,{ 'E': E });t1.HashSetImplementation$0();return t1;};

$.Strings_join = function(strings,separator){return $.StringImplementation_join(strings,separator);};

$.StringImplementation_join = function(strings,separator){$.checkNull(strings);$.checkNull(separator);return $.stringJoinUnchecked($.StringImplementation__toJsStringArray(strings),separator);};

$.add$1 = function(receiver,value){if($.isJsArray(receiver)){$.checkGrowable(receiver,'add');receiver.push(value);return;}return receiver.add$1(value);};

$.get$length = function(receiver){if(typeof receiver==='string'||$.isJsArray(receiver))return receiver.length;else return receiver.get$length();};

$.Uri__parseIntOrZero = function(val){if(!(val==null)&&!$.eqB(val,''))return $.parseInt(val);else return 0;};

$.dynamicBind = function(obj,name$,methods,arguments$){var tag=$.getTypeNameOf(obj);var method=methods[tag];if(method==null&&!($._dynamicMetadata0()==null))for(var i=0;i<$._dynamicMetadata0().length;++i){var entry=$._dynamicMetadata0()[i];if(entry.get$_lib5_set()[tag]){method=methods[entry.get$_tag()];if(!(method==null))break;}}if(method==null)method=methods['Object'];var proto=Object.getPrototypeOf(obj);if(method==null)method=function () {if (Object.getPrototypeOf(this) === proto) {throw new TypeError(name$ + " is not a function");} else {return Object.prototype[name$].apply(this, arguments);}};if(!proto.hasOwnProperty(name$))$.defineProperty(proto,name$,method);return method.apply(obj, arguments$);};

$.regExpMakeNative = function(regExp,global){var pattern=regExp.get$pattern();var multiLine=regExp.get$multiLine();var ignoreCase=regExp.get$ignoreCase();$.checkString(pattern);var sb=$.StringBufferImpl$('');if(multiLine===true)$.add$1(sb,'m');if(ignoreCase===true)$.add$1(sb,'i');if(global)$.add$1(sb,'g');try{return new RegExp(pattern, $.toString(sb));}catch(exception){var t1=$.unwrapException(exception);var e=t1;throw $.$$throw($.IllegalJSRegExpException$(pattern,String(e)));}};

$.main = function(){$.VoteDemo_VoteDemo($.query('#content'),$.query('#pluralityView'),$.query('#distanceView'),$.query('#condorcetView'),$.query('#canManView'))._requestFrame$0();};

$.CondorcetPair_CondorcetPair = function(can1,can2,bals,TVoter,TCandidate){var t1={};t1.can1_1=can1;t1.can2_2=can2;$.requireArgumentNotNull(t1.can1_1,'can1');$.requireArgumentNotNull(t1.can2_2,'can2');$.requireArgument(!$.eqB(t1.can1_1,t1.can2_2),'can1 and can2 must be different',null);if($.gtB($.compareTo(t1.can1_1,t1.can2_2),0)){var temp=t1.can2_2;t1.can2_2=t1.can1_1;t1.can1_1=temp;}if(bals==null)return $.CondorcetPair$_internal(t1.can1_1,t1.can2_2,null,0,0);else{var roBallots=$.ReadOnlyCollection$(bals,'RankedBallot<TVoter, TCandidate>');$.requireArgument($.CollectionUtil_allUnique(roBallots),'Only one ballot per voter is allowed',null);t1.fos_3=0;t1.sof_4=0;roBallots.forEach$1(new $.CondorcetPair_CondorcetPair_anon(t1));return $.CondorcetPair$_internal(t1.can1_1,t1.can2_2,roBallots,t1.fos_3,t1.sof_4);}};

$.FutureValueResult$fromException = function(exception,TOutput){var t1=new $.FutureValueResult(null,exception);$.setRuntimeTypeInfo(t1,{ 'TOutput': TOutput });t1.FutureValueResult$fromException$1(exception);return t1;};

$.ceil = function(receiver){return Math.ceil(receiver);};

$.RgbColor$_internal = function(r,g,b){return new $.RgbColor(r,g,b);};

$._FrozenElementListIterator$ = function(_list){return new $._FrozenElementListIterator(_list,0);};

$.Maps_mapToString = function(m){var result=$.StringBufferImpl$('');$.Maps__emitMap(m,result,$.ListImplementation_List(null));return result.toString$0();};

$.invokeClosure = function(closure,isolate,numberOfArguments,arg1,arg2){if($.eqB(numberOfArguments,0))return $._callInIsolate(isolate,new $.invokeClosure_anon(closure));else if($.eqB(numberOfArguments,1))return $._callInIsolate(isolate,new $.invokeClosure_anon0(closure,arg1));else if($.eqB(numberOfArguments,2))return $._callInIsolate(isolate,new $.invokeClosure_anon1(closure,arg1,arg2));else throw $.$$throw($.ExceptionImplementation$('Unsupported number of arguments for wrapped closure'));};

$._IsolateNatives__getJSFunctionName = function(f){return f.$name || (void 0);};

$.MetaInfo$ = function(_tag,_tags,_set){return new $.MetaInfo(_tag,_tags,_set);};

$.add = function(a,b){return typeof a==='number'&&typeof b==='number'?a + b:$.add$slow(a,b);};

$._DOMWindowCrossFrameImpl__blur = function(win){win.blur()};

$.geB = function(a,b){return typeof a==='number'&&typeof b==='number'?a >= b:$.ge$slow(a,b)===true;};

$._isJavaScriptSimpleObject = function(value){return Object.getPrototypeOf(value) === Object.prototype;};

$.ioore = function(index){throw $.$$throw($.IndexOutOfRangeException$(index));};

$._ChildNodeListLazy$ = function(_this){return new $._ChildNodeListLazy(_this);};

$._callInIsolate = function(isolate,function$){isolate.eval$1(function$);$._globalState().get$topEventLoop().run$0();};

$.compareTo = function(a,b){if($.checkNumbers(a,b))if($.ltB(a,b))return -1;else if($.gtB(a,b))return 1;else if($.eqB(a,b)){if($.eqB(a,0)){var aIsNegative=$.isNegative(a);if($.eqB(aIsNegative,$.isNegative(b)))return 0;if(aIsNegative===true)return -1;return 1;}return 0;}else if($.isNaN(a)===true){if($.isNaN(b)===true)return 0;return 1;}else return -1;else if(typeof a==='string'){if(!(typeof b==='string'))throw $.$$throw($.IllegalArgumentException$(b));if(a == b)var t1=0;else t1=a < b?-1:1;return t1;}else return a.compareTo$1(b);};

$._convertNativeToDart_IDBKey = function(nativeKey){if(new $._convertNativeToDart_IDBKey_containsDate().call$1(nativeKey)===true)throw $.$$throw($.CTC15);return nativeKey;};

$.leB = function(a,b){return typeof a==='number'&&typeof b==='number'?a <= b:$.le$slow(a,b)===true;};

$.mod = function(a,b){if($.checkNumbers(a,b)){var result=a % b;if(result===0)return 0;if(result>0)return result;if(b<0)return result-b;else return result+b;}return a.operator$mod$1(b);};

$._IDBRequestEventsImpl$ = function(_ptr){return new $._IDBRequestEventsImpl(_ptr);};

$._DOMWindowCrossFrameImpl$ = function(_window){return new $._DOMWindowCrossFrameImpl(_window);};

$.CandidateMapElement$ = function(w,h){var t1=$.AffineTransform$(1,0,0,1,0,0);t1=new $.CandidateMapElement($.ListImplementation_List(null,'MapPlayer'),t1,0,null,null,$.ListImplementation_List(null,'AffineTransform'),false,$.EventHandle$('EventArgs'),$.EventHandle$('EventArgs'),null,w,h,null,null,false,null,$.PropertyValues$(),false);t1.CandidateMapElement$2(w,h);return t1;};

$.RetainedUtil_transformPointGlobalToLocal = function(element,point){return element.getTransform$0().createInverse$0().transformCoordinate$1(point);};

$.Collections_collectionToString = function(c){var result=$.StringBufferImpl$('');$.Collections__emitCollection(c,result,$.ListImplementation_List(null));return result.toString$0();};

$.CanvasUtil_centeredCircle = function(ctx,x,y,radius){$.CanvasUtil_ellipse(ctx,$.sub(x,radius),$.sub(y,radius),$.mul(radius,2),$.mul(radius,2));};

$._SharedWorkerContextEventsImpl$ = function(_ptr){return new $._SharedWorkerContextEventsImpl(_ptr);};

$.indexOf$2 = function(receiver,element,start){if($.isJsArray(receiver))return $.Arrays_indexOf(receiver,element,start,receiver.length);else if(typeof receiver==='string'){$.checkNull(element);if(!(typeof element==='string'))throw $.$$throw($.IllegalArgumentException$(element));if(start<0)return -1;return receiver.indexOf(element, start);}return receiver.indexOf$2(element,start);};

$.RetainedUtil_hitTest = function(stage,point){return $.RetainedUtil__hitTest(stage.get$rootElement(),point);};

$.trim = function(receiver){if(!(typeof receiver==='string'))return receiver.trim$0();return receiver.trim();};

$._TextTrackEventsImpl$ = function(_ptr){return new $._TextTrackEventsImpl(_ptr);};

$.DoubleLinkedQueue$ = function(E){var t1=new $.DoubleLinkedQueue(null);$.setRuntimeTypeInfo(t1,{ 'E': E });t1.DoubleLinkedQueue$0();return t1;};

$._distanceElectionIsolate = function(){$.port().receive$1(new $._distanceElectionIsolate_anon());};

$.StringBufferImpl$ = function(content$){var t1=new $.StringBufferImpl(null,null);t1.StringBufferImpl$1(content$);return t1;};

$.getRuntimeTypeInfo = function(target){if(target==null)return;var res=target.builtin$typeInfo;return res==null?{}:res;};

$._SVGElementInstanceEventsImpl$ = function(_ptr){return new $._SVGElementInstanceEventsImpl(_ptr);};

$._MainManagerStub$ = function(){return new $._MainManagerStub();};

$.Grouping$_internal = function(_values,K,V){var t1=new $.Grouping(_values);$.setRuntimeTypeInfo(t1,{ 'K': K, 'V': V });return t1;};

$._TarjanList$_internal = function(_nodes,TNode){var t1=new $._TarjanList(_nodes);$.setRuntimeTypeInfo(t1,{ 'TNode': TNode });return t1;};

$.regExpTest = function(regExp,str){return $.regExpGetNative(regExp).test(str);};

$.Coordinate$ = function(x,y){return new $.Coordinate(x,y);};

$.makeLiteralMap = function(keyValuePairs){var iterator=$.iterator(keyValuePairs);var result=$.LinkedHashMapImplementation$();for(;iterator.hasNext$0()===true;)result.operator$indexSet$2(iterator.next$0(),iterator.next$0());return result;};

$._createMeasurementFuture = function(computeValue,completer){if($._pendingRequests==null){$._pendingRequests=[];$._maybeScheduleMeasurementFrame();}$.add$1($._pendingRequests,$._MeasurementRequest$(computeValue,completer));return completer.get$future();};

$.Tuple$ = function(Item1,Item2,T1,T2){var t1=new $.Tuple(Item1,Item2);$.setRuntimeTypeInfo(t1,{ 'T1': T1, 'T2': T2 });return t1;};

$.Uri__addIfNonEmpty = function(sb,test,first,second){if(!(''===test)){sb.add$1(first==null?'null':first);sb.add$1(second==null?'null':second);}};

$.CollectionUtil_allUnique = function(items){if(typeof items!=='string'&&(typeof items!=='object'||items===null||items.constructor!==Array&&!items.is$JavaScriptIndexingBehavior()))return $.CollectionUtil_allUnique$bailout(1,items);$.requireArgumentNotNull(items,'items');for(var i=0;i<items.length;++i)for(var j=i+1;t1=items.length,j<t1;++j){if(i<0||i>=t1)throw $.ioore(i);var t2=items[i];if(j<0||j>=t1)throw $.ioore(j);if($.eqB(t2,items[j]))return false;}return true;var t1;};

$.NoMoreElementsException$ = function(){return new $.NoMoreElementsException();};

$.addAll = function(receiver,collection){if(!$.isJsArray(receiver))return receiver.addAll$1(collection);var iterator=$.iterator(collection);for(;iterator.hasNext$0()===true;)$.add$1(receiver,iterator.next$0());};

$.gt$slow = function(a,b){if($.checkNumbers(a,b))return a > b;return a.operator$gt$1(b);};

$._IsolateNatives__getEventData = function(e){return e.data};

$.typeNameInChrome = function(obj){var name$=obj.constructor.name;if(name$==='Window')return 'DOMWindow';if(name$==='CanvasPixelArray')return 'Uint8ClampedArray';if(name$==='WebKitMutationObserver')return 'MutationObserver';if(name$==='FormData')return 'DOMFormData';return name$;};

$.Collections__emitCollection = function(c,result,visiting){$.add$1(visiting,c);var isList=typeof c==='object'&&c!==null&&(c.constructor===Array||c.is$List());$.add$1(result,isList?'[':'{');for(var t1=$.iterator(c),first=true;t1.hasNext$0()===true;){var t2=t1.next$0();if(!first)$.add$1(result,', ');$.Collections__emitObject(t2,result,visiting);first=false;}$.add$1(result,isList?']':'}');$.removeLast(visiting);};

$.FilteredElementList$ = function(node){return new $.FilteredElementList(node,node.get$nodes());};

$._document = function(){return document;};

$._FrameSetElementEventsImpl$ = function(_ptr){return new $._FrameSetElementEventsImpl(_ptr);};

$._Elements_TableElement = function(){return $._document().$dom_createElement$1('table');};

$._SelectManyIterator$_internal = function(_sourceIterator,_func,TSource,TOutput){var t1=new $._SelectManyIterator(_sourceIterator,_func,null);$.setRuntimeTypeInfo(t1,{ 'TSource': TSource, 'TOutput': TOutput });return t1;};

$.listInsertRange = function(receiver,start,length$,initialValue){if(typeof receiver!=='object'||receiver===null||(receiver.constructor!==Array||!!receiver.immutable$list)&&!receiver.is$JavaScriptIndexingBehavior())return $.listInsertRange$bailout(1,receiver,start,length$,initialValue);if(length$===0)return;$.checkNull(start);$.checkNull(length$);if(length$<0)throw $.$$throw($.IllegalArgumentException$(length$));var receiverLength=receiver.length;if(start<0||start>receiverLength)throw $.$$throw($.IndexOutOfRangeException$(start));var t1=receiverLength+length$;$.set$length(receiver,t1);var t2=start+length$;$.Arrays_copy(receiver,start,receiver,t2,receiverLength-start);if(!(initialValue==null))for(var i=start;i<t2;++i){if(i<0||i>=receiver.length)throw $.ioore(i);receiver[i]=initialValue;}$.set$length(receiver,t1);};

$._IDBDatabaseEventsImpl$ = function(_ptr){return new $._IDBDatabaseEventsImpl(_ptr);};

$.toStringForNativeObject = function(obj){return 'Instance of '+$.getTypeNameOf(obj);};

$.ltB = function(a,b){return typeof a==='number'&&typeof b==='number'?a < b:$.lt$slow(a,b)===true;};

$.tdiv = function(a,b){if($.checkNumbers(a,b))return $.truncate(a / b);return a.operator$tdiv$1(b);};

$.GlobalId_GlobalId = function(){var t1=$.GlobalId__globalId;$.GlobalId__globalId=$.add(t1,1);return $.GlobalId$_internal(t1);};

$._MediaStreamTrackListEventsImpl$ = function(_ptr){return new $._MediaStreamTrackListEventsImpl(_ptr);};

$.NoSuchMethodException$ = function(_receiver,_functionName,_arguments,existingArgumentNames){return new $.NoSuchMethodException(_receiver,_functionName,_arguments,existingArgumentNames);};

$.S = function(value){var res=$.toString(value);if(!(typeof res==='string'))throw $.$$throw($.IllegalArgumentException$(value));return res;};

$._DoubleLinkedQueueIterator$ = function(_sentinel,E){var t1=new $._DoubleLinkedQueueIterator(_sentinel,null);$.setRuntimeTypeInfo(t1,{ 'E': E });t1._DoubleLinkedQueueIterator$1(_sentinel);return t1;};

$.Grouping_Grouping = function(source,keyFunc,K,V){if(keyFunc==null)keyFunc=new $.Grouping_Grouping_anon();var map=$.NoneHashMap$(K,'List<V>');for(var t1=$.iterator(source);t1.hasNext$0()===true;){var t2=t1.next$0();$.add$1(map.putIfAbsent$2(keyFunc.call$1(t2),new $.Grouping_Grouping_anon0(V)),t2);}return $.Grouping$_internal(map);};

$._VoterHexMapper$ = function(){return new $._VoterHexMapper($.spawnFunction($._voterHexMapperIsolate),null,null,null,null,null,false,$.EventHandle$('EventArgs'),$.EventHandle$('EventArgs'),$.EventHandle$('Object'));};

$._ReceivePortFactory_ReceivePort = function(){return $._ReceivePortImpl$();};

$.$$ = function(source){if(typeof source==='object'&&source!==null&&!!source.is$Enumerable)return source;else return $.Enumerable_Enumerable$fromIterable(source);};

$._Device_isIE = function(){return $._Device_isOpera()!==true&&$.contains$2($._Device_userAgent(),'MSIE',0)===true;};

$.EventHandle$ = function(T){var t1=new $.EventHandle(null,false);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$.sort = function(receiver,compare){if(!$.isJsArray(receiver))return receiver.sort$1(compare);$.checkMutable(receiver,'sort');$.DualPivotQuicksort_sort(receiver,compare);};

$.DualPivotQuicksort_sort = function(a,compare){$.DualPivotQuicksort__doSort(a,0,$.sub($.get$length(a),1),compare);};

$.startRootIsolate = function(entry){var t1=$._Manager$();$._globalState0(t1);if($._globalState().get$isWorker()===true)return;var rootContext=$._IsolateContext$();$._globalState().set$rootContext(rootContext);$._fillStatics(rootContext);$._globalState().set$currentContext(rootContext);if(!($._window()==null))rootContext.eval$1(new $.startRootIsolate_anon());rootContext.eval$1(entry);$._globalState().get$topEventLoop().run$0();};

$.Uri__emptyIfNull = function(val){return !(val==null)?val:'';};

$.stringSplitUnchecked = function(receiver,pattern){return receiver.split(pattern);};

$.lt$slow = function(a,b){if($.checkNumbers(a,b))return a < b;return a.operator$lt$1(b);};

$.Collections__emitObject = function(o,result,visiting){if(typeof o==='object'&&o!==null&&(o.constructor===Array||o.is$Collection()))if($.Collections__containsRef(visiting,o))$.add$1(result,typeof o==='object'&&o!==null&&(o.constructor===Array||o.is$List())?'[...]':'{...}');else $.Collections__emitCollection(o,result,visiting);else if(typeof o==='object'&&o!==null&&o.is$Map())if($.Collections__containsRef(visiting,o))$.add$1(result,'{...}');else $.Maps__emitMap(o,result,visiting);else $.add$1(result,o==null?'null':o);};

$._DedicatedWorkerContextEventsImpl$ = function(_ptr){return new $._DedicatedWorkerContextEventsImpl(_ptr);};

$.NoneHashMap$ = function(K,V){var t1=new $.NoneHashMap($.ListImplementation_List(null,'Tuple<K, V>'));$.setRuntimeTypeInfo(t1,{ 'K': K, 'V': V });return t1;};

$._IsolateNatives__startNonWorker = function(functionName,uri,replyPort){if(!(uri==null))throw $.$$throw($.UnsupportedOperationException$('Currently spawnUri is not supported without web workers.'));$._globalState().get$topEventLoop().enqueue$3($._IsolateContext$(),new $._IsolateNatives__startNonWorker_function(functionName,replyPort),'nonworker start');};

$.VoteDemo_VoteDemo = function(canvas,pluralityDiv,distanceDiv,condorcetDiv,canManDiv){var voterMap=$.RootMapElement$(canvas.get$width(),canvas.get$height());var stage=$.Stage$(canvas,voterMap);var distanceView=$.DistanceView$(distanceDiv);var pluralityView=$.PluralityView$(pluralityDiv);var condorcetView=$.CondorcetView$(condorcetDiv);var canManView=$.CandidateManagerView$(canManDiv);return $.VoteDemo$_internal(canvas,stage,$.Dragger$(canvas),voterMap,condorcetView,pluralityView,distanceView,canManView);};

$._AttributeClassSet$ = function(element){return new $._AttributeClassSet(element);};

$.truncate = function(receiver){return receiver<0?$.ceil(receiver):$.floor(receiver);};

$.StringImplementation_String$fromCharCodes = function(charCodes){return $.StringImplementation__fromCharCodes(charCodes);};

$._EventLoop$ = function(){return new $._EventLoop($.DoubleLinkedQueue$('_IsolateEvent'));};

$.substringUnchecked = function(receiver,startIndex,endIndex){return receiver.substring(startIndex, endIndex);};

$.Primitives_stringFromCharCodes = function(charCodes){for(var t1=$.iterator(charCodes);t1.hasNext$0()===true;){var t2=t1.next$0();if(!(typeof t2==='number'&&Math.floor(t2) === t2))throw $.$$throw($.IllegalArgumentException$(t2));}return String.fromCharCode.apply(null, charCodes);};

$.rnd = function(){if($._dartlibHelperRandom==null)$._dartlibHelperRandom=$.Random_Random(null);return $._dartlibHelperRandom;};

$._convertNativeToDart_IDBAny = function(object){return $._convertNativeToDart_AcceptStructuredClone(object);};

$._AudioContextEventsImpl$ = function(_ptr){return new $._AudioContextEventsImpl(_ptr);};

$.typeNameInSafari = function(obj){var name$=$.constructorNameFallback(obj);if(name$==='Window')return 'DOMWindow';if(name$==='CanvasPixelArray')return 'Uint8ClampedArray';if(name$==='WebKitMutationObserver')return 'MutationObserver';if(name$==='FormData')return 'DOMFormData';return name$;};

$._ElementAttributeMap$ = function(_element){return new $._ElementAttributeMap(_element);};

$.contains$2 = function(receiver,other,startIndex){if(!(typeof receiver==='string'))return receiver.contains$2(other,startIndex);$.checkNull(other);return $.stringContainsUnchecked(receiver,other,startIndex);};

$.regExpMatchStart = function(m){return m.index;};

$._WorkerContextEventsImpl$ = function(_ptr){return new $._WorkerContextEventsImpl(_ptr);};

$._ElementEventsImpl$ = function(_ptr){return new $._ElementEventsImpl(_ptr);};

$._dynamicMetadata = function(table){$dynamicMetadata = table;};

$._dynamicMetadata0 = function(){if(typeof($dynamicMetadata)==='undefined'){var t1=[];$._dynamicMetadata(t1);}return $dynamicMetadata;};

$.isNegative = function(receiver){if(typeof receiver==='number')return receiver===0?1/receiver<0:receiver<0;else return receiver.isNegative$0();};

$.add$slow = function(a,b){if($.checkNumbers(a,b))return a + b;return a.operator$add$1(b);};

$.jsHasOwnProperty = function(jsObject,property){return jsObject.hasOwnProperty(property);};

$.CondorcetView__getPair = function(elem){var pairIdStr=$.index(elem.get$dataAttributes(),'pair-ids');if(!(pairIdStr==null)){var ids=$.$$($.split($.substring$1(pairIdStr,4),'_')).select$1(new $.CondorcetView__getPair_anon()).toList$0();return $.Tuple$($.index(ids,0),$.index(ids,1),'int','int');}return;};

$.Enumerable_Enumerable$fromIterable = function(source,T){$.requireArgumentNotNull(source,'source');return $._SimpleEnumerable$(source,T);};

$._IsolateNatives__spawn = function(functionName,uri,isLight){var completer=$.CompleterImpl$('SendPort');var port=$._ReceivePortFactory_ReceivePort();port.receive$1(new $._IsolateNatives__spawn_anon(port,completer));var signalReply=port.toSendPort$0();if($._globalState().get$useWorkers()===true&&!isLight)$._IsolateNatives__startWorker(functionName,uri,signalReply);else $._IsolateNatives__startNonWorker(functionName,uri,signalReply);return $._BufferingSendPort$($._globalState().get$currentContext().get$id(),completer.get$future());};

$.LocationData_getCandidateName = function(i){$.requireArgument($.ge(i,0),'',null);$.requireArgument($.lt(i,26),'',null);return $.StringImplementation_String$fromCharCodes([$.add(i,65)]);};

$.lastIndexOf$2 = function(receiver,element,start){if($.isJsArray(receiver))return $.Arrays_lastIndexOf(receiver,element,start);else if(typeof receiver==='string'){$.checkNull(element);if(!(start==null)){if(!(typeof start==='number'))throw $.$$throw($.IllegalArgumentException$(start));if(start<0)return -1;var t1=receiver.length;if(start>=t1){if(element==='')return t1;start=t1-1;}else start=start;}return $.stringLastIndexOfUnchecked(receiver,element,start);}return receiver.lastIndexOf$2(element,start);};

$._WindowImpl__isDartLocation = function(thing){try{var t1=thing;return typeof t1==='object'&&t1!==null&&t1.is$Location();}catch(exception){$.unwrapException(exception);return false;}};

$._PendingSendPortFinder$ = function(){var t1=$._MessageTraverserVisitedMap$();t1=new $._PendingSendPortFinder([],t1);t1._PendingSendPortFinder$0();return t1;};

$.Futures_wait = function(futures){var t1={};if(typeof futures!=='string'&&(typeof futures!=='object'||futures===null||futures.constructor!==Array&&!futures.is$JavaScriptIndexingBehavior()))return $.Futures_wait$bailout(1,futures,t1);if($.isEmpty(futures)===true)return $.FutureImpl_FutureImpl$immediate($.CTC10,'List');var completer=$.CompleterImpl$('List');var result=completer.get$future();t1.remaining_1=futures.length;var values=$.ListImplementation_List(futures.length);for(var i=0;t2=futures.length,i<t2;++i){if(i<0||i>=t2)throw $.ioore(i);var future=futures[i];future.then$1(new $.Futures_wait_anon(completer,i,t1,result,values));future.handleException$1(new $.Futures_wait_anon0(future,completer,result));}return result;var t2;};

$._MatchImplementation$ = function(pattern,str,_start,_end,_groups){return new $._MatchImplementation(pattern,str,_start,_end,_groups);};

$.Arrays_copy = function(src,srcStart,dst,dstStart,count){if(typeof src!=='string'&&(typeof src!=='object'||src===null||src.constructor!==Array&&!src.is$JavaScriptIndexingBehavior()))return $.Arrays_copy$bailout(1,src,srcStart,dst,dstStart,count);if(typeof dst!=='object'||dst===null||(dst.constructor!==Array||!!dst.immutable$list)&&!dst.is$JavaScriptIndexingBehavior())return $.Arrays_copy$bailout(1,src,srcStart,dst,dstStart,count);if(srcStart<dstStart)for(var i=srcStart+count-1,j=dstStart+count-1;i>=srcStart;--i,--j){if(i!==(i|0))throw $.iae(i);if(i<0||i>=src.length)throw $.ioore(i);var t1=src[i];if(j!==(j|0))throw $.iae(j);if(j<0||j>=dst.length)throw $.ioore(j);dst[j]=t1;}else for(t1=srcStart+count,i=srcStart,j=dstStart;i<t1;++i,++j){if(i<0||i>=src.length)throw $.ioore(i);var t2=src[i];if(j<0||j>=dst.length)throw $.ioore(j);dst[j]=t2;}};

$.CanvasUtil_ellipse = function(ctx,x,y,width,height){var hB=$.mul($.div(width,2),0.5522847498307935);var vB=$.mul($.div(height,2),0.5522847498307935);var eX=$.add(x,width);var eY=$.add(y,height);var mX=$.add(x,$.div(width,2));var mY=$.add(y,$.div(height,2));ctx.beginPath$0();ctx.moveTo$2(x,mY);ctx.bezierCurveTo$6(x,$.sub(mY,vB),$.sub(mX,hB),y,mX,y);ctx.bezierCurveTo$6($.add(mX,hB),y,eX,$.sub(mY,vB),eX,mY);ctx.bezierCurveTo$6(eX,$.add(mY,vB),$.add(mX,hB),eY,mX,eY);ctx.bezierCurveTo$6($.sub(mX,hB),eY,x,$.add(mY,vB),x,mY);ctx.closePath$0();};

$._PeerConnection00EventsImpl$ = function(_ptr){return new $._PeerConnection00EventsImpl(_ptr);};

$._AbstractWorkerEventsImpl$ = function(_ptr){return new $._AbstractWorkerEventsImpl(_ptr);};

$.indexSet = function(a,index,value){if(a.constructor === Array && !a.immutable$list){var key=index >>> 0;if(key===index&&key<a.length){a[key] = value;return;}}$.indexSet$slow(a,index,value);};

$.index$slow = function(a,index){if(typeof a==='string'||$.isJsArray(a)){if(!(typeof index==='number'&&Math.floor(index) === index)){if(!(typeof index==='number'))throw $.$$throw($.IllegalArgumentException$(index));if(!($.truncate(index)===index))throw $.$$throw($.IllegalArgumentException$(index));}if($.ltB(index,0)||$.geB(index,$.get$length(a)))throw $.$$throw($.IndexOutOfRangeException$(index));return a[index];}return a.operator$index$1(index);};

$.div = function(a,b){return typeof a==='number'&&typeof b==='number'?a / b:$.div$slow(a,b);};

$.DistanceBallot_DistanceBallot = function(voter,candidates,TVoter,TCandidate){var distances=$.$$(candidates).toHashMap$1(new $.DistanceBallot_DistanceBallot_anon(voter));var rank=$.ListImplementation_List$from(candidates,'MapPlayer');$.requireArgument(rank.length>0,'candidates',null);$.requireArgument($.CollectionUtil_allUnique(rank),'candidates',null);$.sort(rank,new $.DistanceBallot_DistanceBallot_anon0(distances));return $.DistanceBallot$_internal(voter,$.ReadOnlyCollection$(rank),distances);};

$._Elements_CanvasElement = function(width,height){var _e=$._document().$dom_createElement$1('canvas');if(!(width==null))_e.set$width(width);if(!(height==null))_e.set$height(height);return _e;};

$.Uri$fromString = function(uri){var t1=$.CTC16.firstMatch$1(uri);return new $.Uri($.Uri__emptyIfNull($.index(t1,1)),$.Uri__emptyIfNull($.index(t1,2)),$.Uri__emptyIfNull($.index(t1,3)),$.Uri__parseIntOrZero($.index(t1,4)),$.Uri__emptyIfNull($.index(t1,5)),$.Uri__emptyIfNull($.index(t1,6)),$.Uri__emptyIfNull($.index(t1,7)));};

$.$$throw = function(ex){if(ex==null)ex=$.CTC0;var jsError=new Error();jsError.name = ex;jsError.description = ex;jsError.dartException = ex;jsError.toString = $.toStringWrapper.call$0;throw jsError;};

$._MessagePortEventsImpl$ = function(_ptr){return new $._MessagePortEventsImpl(_ptr);};

$._IsolateEvent$ = function(isolate,fn,message){return new $._IsolateEvent(isolate,fn,message);};

$.ElectionPlace$ = function(place,candidates,TCandidate){var t1=new $.ElectionPlace(place,$.ListImplementation_List$from(candidates,$.getRuntimeTypeInfo(this).T));$.setRuntimeTypeInfo(t1,{ 'TCandidate': TCandidate });t1.ElectionPlace$2(place,candidates);return t1;};

$.ReadOnlyCollection$ = function(source,T){var t1=new $.ReadOnlyCollection($.ListImplementation_List$from(source,$.getRuntimeTypeInfo(this).T));$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$._Device_isFirefox = function(){return $.contains$2($._Device_userAgent(),'Firefox',0);};

$.min = function(a,b){if(typeof a==='number'){if(typeof b==='number'){if(a>b)return b;if(a<b)return a;if(typeof b==='number'){if(typeof a==='number')if(a===0)return (a+b)*a*b;if(a===0&&$.isNegative(b)===true||$.isNaN(b)===true)return b;return a;}return a;}throw $.$$throw($.IllegalArgumentException$(b));}throw $.$$throw($.IllegalArgumentException$(a));};

$._IsolateNatives__newWorker = function(url){return new Worker(url);};

$._LocationWrapper__toString = function(p){return p.toString();};

$.checkMutable = function(list,reason){if(!!(list.immutable$list))throw $.$$throw($.UnsupportedOperationException$(reason));};

$.CondorcetElection_CondorcetElection = function(ballots,TVoter,TCandidate){var roBallots=$.$$(ballots).toReadOnlyCollection$0();$.requireArgument($.CollectionUtil_allUnique(roBallots.select$1(new $.CondorcetElection_CondorcetElection_anon()).toReadOnlyCollection$0()),'Only one ballot per voter is allowed',null);var hashMap=$.HashMapImplementation$('CondorcetPair<TVoter, TCandidate>','List<RankedBallot<TVoter, TCandidate>>');var candidateHashSet=$.HashSetImplementation$(TCandidate);for(var t1=$.iterator(ballots);t1.hasNext$0()===true;){var t2=t1.next$0();for(var i=0;$.ltB(i,$.get$length(t2.get$rank()));++i){var candidateI=$.index(t2.get$rank(),i);candidateHashSet.add$1(candidateI);for(var j=i+1;$.ltB(j,$.get$length(t2.get$rank()));++j)$.add$1(hashMap.putIfAbsent$2($.CondorcetPair_CondorcetPair(candidateI,$.index(t2.get$rank(),j),null),new $.CondorcetElection_CondorcetElection_anon0(TVoter,TCandidate)),t2);}}var hashSet=$.HashSetImplementation$('CondorcetPair<TVoter, TCandidate>');hashMap.forEach$1(new $.CondorcetElection_CondorcetElection_anon1(hashSet));var candidateProfiles=$.HashMapImplementation$(TCandidate,'CondorcetCandidateProfile<TCandidate>');var tarjanMap=$.HashMapImplementation$(TCandidate,'HashSet<TCandidate>');for(t1=$.iterator(candidateHashSet);t1.hasNext$0()===true;){t2=t1.next$0();var lostTo=$.ListImplementation_List(null,TCandidate);var beat=$.ListImplementation_List(null,TCandidate);var tied=$.ListImplementation_List(null,TCandidate);var tarjanLostTiedSet=$.HashSetImplementation$(TCandidate);for(var t3=$.iterator(hashSet);t3.hasNext$0()===true;){var t4=t3.next$0();if($.eqB(t4.get$Item1(),t2)||$.eqB(t4.get$Item2(),t2)){var other=$.eqB(t4.get$Item1(),t2)?t4.get$Item2():t4.get$Item1();if(t4.get$isTie()===true){tied.push(other);tarjanLostTiedSet.add$1(other);}else if($.eqB(t4.get$winner(),t2))beat.push(other);else{lostTo.push(other);tarjanLostTiedSet.add$1(other);}}}candidateProfiles.operator$indexSet$2(t2,$.CondorcetCandidateProfile$_internal(t2,$.ReadOnlyCollection$(lostTo),$.ReadOnlyCollection$(beat),$.ReadOnlyCollection$(tied)));tarjanMap.operator$indexSet$2(t2,tarjanLostTiedSet);}var components=$.TarjanCycleDetect_getStronglyConnectedComponents(tarjanMap);var places=$.ListImplementation_List(null,'ElectionPlace<TCandidate>');for(var t1=$.iterator(components),placeNumber=1;t1.hasNext$0()===true;){t2=t1.next$0();places.push($.ElectionPlace$(placeNumber,t2));t2=$.get$length(t2);if(typeof t2!=='number')throw $.iae(t2);placeNumber+=t2;}return $.CondorcetElection$_internal(hashSet,candidateProfiles,roBallots,$.ReadOnlyCollection$(places,'ElectionPlace<TCandidate>'));};

$.FutureValueResult_isMyMap = function(value){return !(value==null)&&$.eqB($.get$length(value),2)&&value.containsKey$1('value')===true&&value.containsKey$1('exception')===true;};

$.index = function(a,index){if(typeof a == "string" || a.constructor === Array){var key=index >>> 0;if(key===index&&key<a.length)return a[key];}return $.index$slow(a,index);};

$.le$slow = function(a,b){if($.checkNumbers(a,b))return a <= b;return a.operator$le$1(b);};

$.RetainedUtil__hitTest = function(element,point){point=$.RetainedUtil_transformPointGlobalToLocal(element,point);var bounds=$.Rect$(0,0,element.get$width(),element.get$height());var hits=$.ListImplementation_List(null,'PElement');if(bounds.contains$1(point)===true){var length$=element.get$visualChildCount();if(typeof length$!=='number')return $.RetainedUtil__hitTest$bailout(1,element,length$,point,hits);for(var t1=length$-1,i=0;i<length$;++i){hits=$.RetainedUtil__hitTest(element.getVisualChild$1(t1-i),point);if(hits.length>0)break;}hits.push(element);return hits;}else return [];};

$.typeNameInOpera = function(obj){var name$=$.constructorNameFallback(obj);if(name$==='Window')return 'DOMWindow';if(name$==='FormData')return 'DOMFormData';return name$;};

$.xor = function(a,b){if($.checkNumbers(a,b))return (a ^ b) >>> 0;return a.operator$xor$1(b);};

$.last = function(receiver){if(!$.isJsArray(receiver))return receiver.last$0();return $.index(receiver,$.sub($.get$length(receiver),1));};

$._window = function(){return typeof window != "undefined"?window:null;};

$.substring$1 = function(receiver,startIndex){if(!(typeof receiver==='string'))return receiver.substring$1(startIndex);return $.substring$2(receiver,startIndex,null);};

$.CanvasUtil_getCanvasSize = function(canvasElement){return $.Size$(canvasElement.get$width(),canvasElement.get$height());};

$.NotImplementedException$ = function(message){return new $.NotImplementedException(message);};

$.HslColor__hueToRgb = function(v1,v2,vH){vH=$.mod(vH,1);if(typeof vH!=='number')throw $.iae(vH);if(6*vH<1)return v1+(v2-v1)*6*vH;else if(2*vH<1)return v2;else if(3*vH<2)return v1+(v2-v1)*(0.6666666666666666-vH)*6;return v1;};

$.eq = function(a,b){if(a == null)return b == null;if(b == null)return false;if(typeof a === "object")if(!!a.operator$eq$1)return a.operator$eq$1(b);return a === b;};

$.NullPointerException$ = function(functionName,arguments$){return new $.NullPointerException(functionName,arguments$);};

$._DoubleLinkedQueueEntrySentinel$ = function(E){var t1=new $._DoubleLinkedQueueEntrySentinel(null,null,null);$.setRuntimeTypeInfo(t1,{ 'E': E });t1.DoubleLinkedQueueEntry$1(null);t1._DoubleLinkedQueueEntrySentinel$0();return t1;};

$.toStringWrapper = function(){return $.toString(this.dartException);};

$._ElementList$ = function(list){return new $._ElementList(list);};

$.gtB = function(a,b){return typeof a==='number'&&typeof b==='number'?a > b:$.gt$slow(a,b)===true;};

$.DistanceView$ = function(node){var t1=new $.DistanceView(null,node,null);t1.HtmlView$1(node);return t1;};

$.stringContainsUnchecked = function(receiver,other,startIndex){return !($.indexOf$2(receiver,other,startIndex)===-1);};

$.shl = function(a,b){if($.checkNumbers(a,b)){if(b<0)throw $.$$throw($.IllegalArgumentException$(b));if(b > 31)return 0;return (a << b) >>> 0;}return a.operator$shl$1(b);};

$.requireArgument = function(truth,arg,message){if(truth!==true)if(!(message==null))throw $.$$throw($.DetailedIllegalArgumentException$(arg,message));else throw $.$$throw($.IllegalArgumentException$(arg));};

$.Primitives_objectToString = function(object){return 'Instance of \''+$.S($.Primitives_objectTypeName(object))+'\'';};

$._currentIsolate = function(){return $._globalState().get$currentContext();};

$.insertRange$3 = function(receiver,start,length$,initialValue){if(!$.isJsArray(receiver))return receiver.insertRange$3(start,length$,initialValue);return $.listInsertRange(receiver,start,length$,initialValue);};

$._completeMeasurementFutures = function(){if($.eqB($._nextMeasurementFrameScheduled,false))return;$._nextMeasurementFrameScheduled=false;if(!($._pendingRequests==null))for(var t1=$.iterator($._pendingRequests);t1.hasNext$0()===true;){var request=t1.next$0();try{var t2=request.computeValue$0();request.set$value(t2);}catch(exception){t2=$.unwrapException(exception);var e=t2;t2=e;request.set$value(t2);request.set$exception(true);}}var completedRequests=$._pendingRequests;var readyMeasurementFrameCallbacks=$._pendingMeasurementFrameCallbacks;$._pendingRequests=null;$._pendingMeasurementFrameCallbacks=null;if(!(completedRequests==null))for(t1=$.iterator(completedRequests);t1.hasNext$0()===true;){t2=t1.next$0();if(t2.get$exception()===true)t2.get$completer().completeException$1(t2.get$value());else t2.get$completer().complete$1(t2.get$value());}if(!(readyMeasurementFrameCallbacks==null))for(t1=$.iterator(readyMeasurementFrameCallbacks);t1.hasNext$0()===true;)t1.next$0().call$0();};

$._DOMWindowCrossFrameImpl__postMessage2 = function(win,message,targetOrigin){    win.postMessage(message, targetOrigin);
};

$._NotificationEventsImpl$ = function(_ptr){return new $._NotificationEventsImpl(_ptr);};

$.toStringAsFixed = function(receiver,fractionDigits){if(!(typeof receiver==='number'))return receiver.toStringAsFixed$1(fractionDigits);$.checkNum(fractionDigits);var result=receiver.toFixed(fractionDigits);if(receiver===0&&$.isNegative(receiver)===true)return '-'+result;return result;};

$._TarjanNode$ = function(value,TNode){var t1=new $._TarjanNode(value,-1,null);$.setRuntimeTypeInfo(t1,{ 'TNode': TNode });return t1;};

$.Coordinate_difference = function(a,b){return $.Vector$($.sub(a.x,b.get$x()),$.sub(a.y,b.get$y()));};

$.DoubleLinkedQueueEntry$ = function(e,E){var t1=new $.DoubleLinkedQueueEntry(null,null,null);$.setRuntimeTypeInfo(t1,{ 'E': E });t1.DoubleLinkedQueueEntry$1(e);return t1;};

$.getMouseEventCoordinate = function(event$){return $.Coordinate$(event$.get$offsetX(),event$.get$offsetY());};

$._CssClassSet$ = function(_element){return new $._CssClassSet(_element);};

$.startsWith = function(receiver,other){if(!(typeof receiver==='string'))return receiver.startsWith$1(other);$.checkString(other);var length$=other.length;if(length$>receiver.length)return false;return other == receiver.substring(0, length$);};

$.getRange = function(receiver,start,length$){if(!$.isJsArray(receiver))return receiver.getRange$2(start,length$);if(0===length$)return [];$.checkNull(start);$.checkNull(length$);if(!(typeof start==='number'&&Math.floor(start) === start))throw $.$$throw($.IllegalArgumentException$(start));if(!(typeof length$==='number'&&Math.floor(length$) === length$))throw $.$$throw($.IllegalArgumentException$(length$));var t1=length$<0;if(t1)throw $.$$throw($.IllegalArgumentException$(length$));if(start<0)throw $.$$throw($.IndexOutOfRangeException$(start));var end=start+length$;if($.gtB(end,$.get$length(receiver)))throw $.$$throw($.IndexOutOfRangeException$(length$));if(t1)throw $.$$throw($.IllegalArgumentException$(length$));return receiver.slice(start, end);};

$._Lists_getRange = function(a,start,length$,accumulator){if(typeof a!=='string'&&(typeof a!=='object'||a===null||a.constructor!==Array&&!a.is$JavaScriptIndexingBehavior()))return $._Lists_getRange$bailout(1,a,start,length$,accumulator);if(typeof start!=='number')return $._Lists_getRange$bailout(1,a,start,length$,accumulator);if($.ltB(length$,0))throw $.$$throw($.IllegalArgumentException$('length'));if(start<0)throw $.$$throw($.IndexOutOfRangeException$(start));if(typeof length$!=='number')throw $.iae(length$);var end=start+length$;if(end>a.length)throw $.$$throw($.IndexOutOfRangeException$(end));for(var i=start;i<end;++i){if(i!==(i|0))throw $.iae(i);if(i<0||i>=a.length)throw $.ioore(i);accumulator.push(a[i]);}return accumulator;};

$.FutureAlreadyCompleteException$ = function(){return new $.FutureAlreadyCompleteException();};

$._DOMWindowCrossFrameImpl__postMessage3 = function(win,message,targetOrigin,messagePorts){    win.postMessage(message, targetOrigin, messagePorts);
};

$.convertDartClosureToJS = function(closure,arity){if(closure==null)return;var function$=closure.$identity;if(!!function$)return function$;function$=function() {
    return $.invokeClosure.call$5(closure, $._currentIsolate(), arity, arguments[0], arguments[1]);
  };closure.$identity = function$;return function$;};

$.TarjanCycleDetect$_internal = function(_list,TNode){var t1=new $.TarjanCycleDetect(0,$.ListImplementation_List(null,'_TarjanNode<TNode>'),$.ListImplementation_List(null,'List<TNode>'),_list);$.setRuntimeTypeInfo(t1,{ 'TNode': TNode });return t1;};

$.CondorcetPair$_internal = function(can1,can2,ballots,firstOverSecond,secondOverFirst,TVoter,TCandidate){var t1=new $.CondorcetPair(ballots,firstOverSecond,secondOverFirst,can1,can2);$.setRuntimeTypeInfo(t1,{ 'TVoter': TVoter, 'TCandidate': TCandidate });return t1;};

$.ObjectNotClosureException$ = function(){return new $.ObjectNotClosureException();};

$.Primitives_objectTypeName = function(object){var name$=$.constructorNameFallback(object);if($.eqB(name$,'Object')){var decompiled=String(object.constructor).match(/^\s*function\s*(\S*)\s*\(/)[1];if(typeof decompiled==='string')name$=decompiled;}return $.charCodeAt(name$,0)===36?$.substring$1(name$,1):name$;};

$.clear = function(receiver){if(!$.isJsArray(receiver))return receiver.clear$0();$.set$length(receiver,0);};

$.IndexIterator$ = function(length$,indexer,T){var t1=new $.IndexIterator(indexer,length$,0);$.setRuntimeTypeInfo(t1,{ 'T': T });t1.IndexIterator$2(length$,indexer);return t1;};

$.HashSetIterator$ = function(set_,E){var t1=new $.HashSetIterator(set_.get$_backingMap().get$_keys(),-1);$.setRuntimeTypeInfo(t1,{ 'E': E });t1.HashSetIterator$1(set_);return t1;};

$.round = function(receiver){if(!(typeof receiver==='number'))return receiver.round$0();if(receiver < 0)return -Math.round(-receiver);else return Math.round(receiver);};

$.print = function(object){$.PrintImplementation_print(object);};

$.PrintImplementation_print = function(obj){if(typeof obj==='string')$.Primitives_printString(obj);else $.Primitives_printString($.toString(obj));};

$._DOMWindowCrossFrameImpl__close = function(win){win.close()};

$.StackOverflowException$ = function(){return new $.StackOverflowException();};

$.forEach = function(receiver,f){if(!$.isJsArray(receiver))return receiver.forEach$1(f);else return $.Collections_forEach(receiver,f);};

$.isEmpty = function(receiver){if(typeof receiver==='string'||$.isJsArray(receiver))return receiver.length === 0;return receiver.isEmpty$0();};

$.Collections_forEach = function(iterable,f){for(var t1=$.iterator(iterable);t1.hasNext$0()===true;)f.call$1(t1.next$0());};

$.LocationData$ = function(voters,candidates){var t1=new $.LocationData(candidates,voters);t1.LocationData$2(voters,candidates);return t1;};

$._convertNativeToDart_AcceptStructuredClone = function(object){var values=[];var copies=[];var t1=new $._convertNativeToDart_AcceptStructuredClone_findSlot(copies,values);var t2=new $._convertNativeToDart_AcceptStructuredClone_readSlot(copies);return new $._convertNativeToDart_AcceptStructuredClone_walk(new $._convertNativeToDart_AcceptStructuredClone_writeSlot(copies),t1,t2).call$1(object);};

$.max = function(a,b){if(typeof a==='number'){if(typeof b==='number'){if(a>b)return a;if(a<b)return b;if(typeof b==='number'){if(typeof a==='number')if(a===0)return a+b;if($.isNaN(b)===true)return b;return a;}if(b===0&&$.isNegative(a)===true)return b;return a;}throw $.$$throw($.IllegalArgumentException$(b));}throw $.$$throw($.IllegalArgumentException$(a));};

$._FrozenElementList$_wrap = function(_nodeList){return new $._FrozenElementList(_nodeList);};

$._Collections_forEach = function(iterable,f){for(var t1=$.iterator(iterable);t1.hasNext$0()===true;)f.call$1(t1.next$0());};

$._FrozenCSSClassSet$ = function(){return new $._FrozenCSSClassSet(null);};

$.CondorcetElection$_internal = function(_pairs,_profiles,ballots,places,TVoter,TCandidate){var t1=new $.CondorcetElection(_pairs,_profiles,ballots,places);$.setRuntimeTypeInfo(t1,{ 'TVoter': TVoter, 'TCandidate': TCandidate });return t1;};

$.DualPivotQuicksort_insertionSort_ = function(a,left,right,compare){if(typeof a!=='object'||a===null||(a.constructor!==Array||!!a.immutable$list)&&!a.is$JavaScriptIndexingBehavior())return $.DualPivotQuicksort_insertionSort_$bailout(1,a,left,right,compare);if(typeof right!=='number')return $.DualPivotQuicksort_insertionSort_$bailout(1,a,left,right,compare);for(var i=left+1;i<=right;++i){if(i!==(i|0))throw $.iae(i);if(i<0||i>=a.length)throw $.ioore(i);var el=a[i];var j=i;while(true){if(j>left){var t1=j-1;if(t1!==(t1|0))throw $.iae(t1);if(t1<0||t1>=a.length)throw $.ioore(t1);var t2=$.gtB(compare.call$2(a[t1],el),0);t1=t2;}else t1=false;if(!t1)break;var j0=j-1;if(j0!==(j0|0))throw $.iae(j0);t1=a.length;if(j0<0||j0>=t1)throw $.ioore(j0);t2=a[j0];if(j!==(j|0))throw $.iae(j);if(j<0||j>=t1)throw $.ioore(j);a[j]=t2;j=j0;}if(j!==(j|0))throw $.iae(j);if(j<0||j>=a.length)throw $.ioore(j);a[j]=el;}};

$.ge$slow = function(a,b){if($.checkNumbers(a,b))return a >= b;return a.operator$ge$1(b);};

$.getFunctionForTypeNameOf = function(){if(!(typeof(navigator)==='object'))return $.typeNameInChrome;var userAgent=navigator.userAgent;if($.contains(userAgent,'Chrome')||$.contains(userAgent,'DumpRenderTree'))return $.typeNameInChrome;else if($.contains(userAgent,'Firefox'))return $.typeNameInFirefox;else if($.contains(userAgent,'MSIE'))return $.typeNameInIE;else if($.contains(userAgent,'Opera'))return $.typeNameInOpera;else if($.contains(userAgent,'Safari'))return $.typeNameInSafari;else return $.constructorNameFallback;};

$.indexSet$slow = function(a,index,value){if($.isJsArray(a)){if(!(typeof index==='number'&&Math.floor(index) === index))throw $.$$throw($.IllegalArgumentException$(index));if(index<0||$.geB(index,$.get$length(a)))throw $.$$throw($.IndexOutOfRangeException$(index));$.checkMutable(a,'indexed set');a[index] = value;return;}a.operator$indexSet$2(index,value);};

$._pluralityElectionIsolate = function(){$.port().receive$1(new $._pluralityElectionIsolate_anon());};

$.gt = function(a,b){return typeof a==='number'&&typeof b==='number'?a > b:$.gt$slow(a,b);};

$._IsolateContext$ = function(){var t1=new $._IsolateContext(null,null,null);t1._IsolateContext$0();return t1;};

$.charCodeAt = function(receiver,index){if(typeof receiver==='string'){if(index<0)throw $.$$throw($.IndexOutOfRangeException$(index));if(index>=receiver.length)throw $.$$throw($.IndexOutOfRangeException$(index));return receiver.charCodeAt(index);}else return receiver.charCodeAt$1(index);};

$.Dragger$ = function(_element){var t1=new $.Dragger(_element,$.EventHandle$('Vector'),$.EventHandle$('CancelableEventArgs'),null);t1.Dragger$1(_element);return t1;};

$.StringImplementation__fromCharCodes = function(charCodes){$.checkNull(charCodes);if(!$.isJsArray(charCodes))charCodes=$.ListImplementation_List$from(charCodes);return $.Primitives_stringFromCharCodes(charCodes);};

$.removeRange = function(receiver,start,length$){if(!$.isJsArray(receiver))return receiver.removeRange$2(start,length$);$.checkGrowable(receiver,'removeRange');if(length$===0)return;$.checkNull(start);$.checkNull(length$);if(length$<0)throw $.$$throw($.IllegalArgumentException$(length$));var receiverLength=receiver.length;if(start<0||start>=receiverLength)throw $.$$throw($.IndexOutOfRangeException$(start));var t1=start+length$;if(t1>receiverLength)throw $.$$throw($.IndexOutOfRangeException$(t1));var t2=receiverLength-length$;$.Arrays_copy(receiver,t1,receiver,start,t2-start);$.set$length(receiver,t2);};

$.ListImplementation_List = function(length$,E){return $.Primitives_newList(length$);};

$.mul = function(a,b){return typeof a==='number'&&typeof b==='number'?a * b:$.mul$slow(a,b);};

$._browserPrefix = function(){if($._cachedBrowserPrefix==null)if($._Device_isFirefox()===true)$._cachedBrowserPrefix='-moz-';else if($._Device_isIE()===true)$._cachedBrowserPrefix='-ms-';else if($._Device_isOpera()===true)$._cachedBrowserPrefix='-o-';else $._cachedBrowserPrefix='-webkit-';return $._cachedBrowserPrefix;};

$._BodyElementEventsImpl$ = function(_ptr){return new $._BodyElementEventsImpl(_ptr);};

$._IsolateNatives__log = function(msg){if($._globalState().get$isWorker()===true)$._globalState().get$mainManager().postMessage$1($._serializeMessage($.makeLiteralMap(['command','log','msg',msg])));else try{$._IsolateNatives__consoleLog(msg);}catch(exception){$.unwrapException(exception);var trace=$.getTraceFromException(exception);throw $.$$throw($.ExceptionImplementation$(trace));}};

$.DistanceElection_DistanceElection = function(voters,candidates,TVoter,TCandidate){var t1={};var cans=$.ReadOnlyCollection$(candidates,TCandidate);var ballots=$.$$(voters).select$1(new $.DistanceElection_DistanceElection_anon(cans)).toReadOnlyCollection$0();var distanceGroups=$.$$(cans).group$1(new $.DistanceElection_DistanceElection_anon0(ballots));var distances=$.ListImplementation_List$from(distanceGroups.getKeys$0(),'Tuple<num, num>');$.sort(distances,new $.DistanceElection_DistanceElection_anon1());t1.placeNumber_1=1;return $.DistanceElection$_internal(cans,ballots,$.$$(distances).select$1(new $.DistanceElection_DistanceElection_anon2(t1,distanceGroups)).toReadOnlyCollection$0());};

$.parseInt = function(str){$.checkString(str);if(!/^\s*[+-]?(?:0[xX][abcdefABCDEF0-9]+|\d+)\s*$/.test(str))throw $.$$throw($.FormatException$(str));var trimmed=$.trim(str);if($.gtB($.get$length(trimmed),2))var t1=$.eqB($.index(trimmed,1),'x')||$.eqB($.index(trimmed,1),'X');else t1=false;if(!t1)if($.gtB($.get$length(trimmed),3))t1=$.eqB($.index(trimmed,2),'x')||$.eqB($.index(trimmed,2),'X');else t1=false;else t1=true;var base=t1?16:10;var ret=parseInt(trimmed, base);if($.isNaN(ret)===true)throw $.$$throw($.FormatException$(str));return ret;};

$._Timer$ = function(milliSeconds,callback){var t1=new $._Timer(true,null);t1._Timer$2(milliSeconds,callback);return t1;};

$.isNaN = function(receiver){if(typeof receiver==='number')return isNaN(receiver);else return receiver.isNaN$0();};

$.iterator = function(receiver){if($.isJsArray(receiver))return $.ListIterator$(receiver);return receiver.iterator$0();};

$.port = function(){if($._lazyPort==null)$._lazyPort=$._ReceivePortFactory_ReceivePort();return $._lazyPort;};

$.CandidateElement$ = function(w,h,_color,p){var t1=new $.CandidateElement(_color,p,p.get$name(),null,false,$.ListImplementation_List(null,'AffineTransform'),false,$.EventHandle$('EventArgs'),$.EventHandle$('EventArgs'),null,w,h,null,null,false,null,$.PropertyValues$(),false);t1.CandidateElement$4(w,h,_color,p);return t1;};

$.toInt = function(receiver){if(!(typeof receiver==='number'))return receiver.toInt$0();if($.isNaN(receiver)===true)throw $.$$throw($.FormatException$('NaN'));if($.isInfinite(receiver)===true)throw $.$$throw($.FormatException$('Infinity'));var truncated=$.truncate(receiver);return truncated == -0.0?0:truncated;};

$.lastIndexOf$1 = function(receiver,element){if($.isJsArray(receiver))return $.Arrays_lastIndexOf(receiver,element,receiver.length);else if(typeof receiver==='string'){$.checkNull(element);return receiver.lastIndexOf(element);}return receiver.lastIndexOf$1(element);};

$._PluralityElectionMapper$ = function(){return new $._PluralityElectionMapper($.spawnFunction($._pluralityElectionIsolate),null,null,null,null,null,false,$.EventHandle$('EventArgs'),$.EventHandle$('EventArgs'),$.EventHandle$('Object'));};

$.VoterMapElement$ = function(w,h){var t1=$.AffineTransform$(1,0,0,1,0,0);t1=new $.VoterMapElement($.ListImplementation_List(null,'MapPlayer'),t1,null,null,$.ListImplementation_List(null,'AffineTransform'),true,$.EventHandle$('EventArgs'),$.EventHandle$('EventArgs'),null,w,h,null,null,false,null,$.PropertyValues$(),false);t1.VoterMapElement$2(w,h);return t1;};

$.PropertyValues$ = function(){return new $.PropertyValues($.NoneHashMap$('Property','Object'),$.EventHandle$('Property'),false);};

$.PluralityElection$_internal = function(ballots,_ballotGroup,sourcePlaces,TVoter,TCandidate){var t1=new $.PluralityElection(ballots,_ballotGroup,$.ReadOnlyCollection$(sourcePlaces));$.setRuntimeTypeInfo(t1,{ 'TVoter': TVoter, 'TCandidate': TCandidate });return t1;};

$.LocationData__slice = function(itemCount,maxValue,sliceCount){var values=$.ListImplementation_List(itemCount,'num');var sliceSize=maxValue/sliceCount;for(var index=0,i=0;i<sliceCount;++i){if(index===itemCount)return values;else{var index0=index+1;var t1=i*sliceSize;if(index<0||index>=values.length)throw $.ioore(index);values[index]=t1;}index=index0;}for(;true;){sliceSize=maxValue/(index*2);for(index0=index,i=0;i<index;++i){if(index0===itemCount)return values;else{var index1=index0+1;if(i<0||i>=values.length)throw $.ioore(i);t1=$.add(values[i],sliceSize);if(index0<0||index0>=values.length)throw $.ioore(index0);values[index0]=t1;}index0=index1;}index=index0;}};

$.GlobalId$_internal = function(value){return new $.GlobalId(value,$.Util_getHashCode([value]));};

$._ElementRectImpl$ = function(element){return new $._ElementRectImpl($._SimpleClientRect$(element.get$$$dom_clientLeft(),element.get$$$dom_clientTop(),element.get$$$dom_clientWidth(),element.get$$$dom_clientHeight()),$._SimpleClientRect$(element.get$$$dom_offsetLeft(),element.get$$$dom_offsetTop(),element.get$$$dom_offsetWidth(),element.get$$$dom_offsetHeight()),$._SimpleClientRect$(element.get$$$dom_scrollLeft(),element.get$$$dom_scrollTop(),element.get$$$dom_scrollWidth(),element.get$$$dom_scrollHeight()),element.$dom_getBoundingClientRect$0(),element.$dom_getClientRects$0());};

$.UnsupportedOperationException$ = function(_message){return new $.UnsupportedOperationException(_message);};

$.removeLast = function(receiver){if($.isJsArray(receiver)){$.checkGrowable(receiver,'removeLast');if($.get$length(receiver)===0)throw $.$$throw($.IndexOutOfRangeException$(-1));return receiver.pop();}return receiver.removeLast$0();};

$._BufferingSendPort$ = function(isolateId,_futurePort){var t1=new $._BufferingSendPort($._BufferingSendPort__idCount,null,_futurePort,[],isolateId);t1._BufferingSendPort$2(isolateId,_futurePort);return t1;};

$.addLast = function(receiver,value){if(!$.isJsArray(receiver))return receiver.addLast$1(value);$.checkGrowable(receiver,'addLast');receiver.push(value);};

$._HttpRequestEventsImpl$ = function(_ptr){return new $._HttpRequestEventsImpl(_ptr);};

$._IsolateNatives__getJSFunctionFromName = function(functionName){    return $globalThis[functionName];
  };

$._JsDeserializer$ = function(){return new $._JsDeserializer(null);};

$._SelectIterator$ = function(_source,_func,TSource,TOutput){var t1=new $._SelectIterator(_source,_func);$.setRuntimeTypeInfo(t1,{ 'TSource': TSource, 'TOutput': TOutput });return t1;};

$.Primitives_printString = function(string){if(typeof dartPrint == "function"){dartPrint(string);return;}if(typeof console == "object"){console.log(string);return;}if(typeof write == "function"){write(string);write("\n");}};

$.dynamicSetMetadata = function(inputTable){var t1=$.buildDynamicMetadata(inputTable);$._dynamicMetadata(t1);};

$.PluralityElection_PluralityElection = function(ballots,TVoter,TCandidate){var roBallots=$.$$(ballots).toReadOnlyCollection$0();$.requireArgument($.CollectionUtil_allUnique(roBallots.select$1(new $.PluralityElection_PluralityElection_anon()).toReadOnlyCollection$0()),'Only one ballot per voter is allowed',null);var group=roBallots.group$1(new $.PluralityElection_PluralityElection_anon0());var voteCounts=$.HashMapImplementation$('int','List<TCandidate>');$.forEach(group,new $.PluralityElection_PluralityElection_anon1(TCandidate,voteCounts));var ballotCounts=$.ListImplementation_List$from(voteCounts.getKeys$0(),'int');$.sort(ballotCounts,new $.PluralityElection_PluralityElection_anon2());var places=$.ListImplementation_List(null,'PluralityElectionPlace<TCandidate>');for(var t1=$.iterator(ballotCounts),place=1;t1.hasNext$0()===true;){var t2=t1.next$0();var p=$.PluralityElectionPlace$(place,voteCounts.operator$index$1(t2),t2);places.push(p);t2=$.get$length(p);if(typeof t2!=='number')throw $.iae(t2);place+=t2;}return $.PluralityElection$_internal(roBallots,group,places);};

$._Elements_ButtonElement = function(){return $._document().$dom_createElement$1('button');};

$.typeNameInFirefox = function(obj){var name$=$.constructorNameFallback(obj);if(name$==='Window')return 'DOMWindow';if(name$==='Document')return 'HTMLDocument';if(name$==='XMLDocument')return 'Document';if(name$==='WorkerMessageEvent')return 'MessageEvent';if(name$==='DragEvent')return 'MouseEvent';if(name$==='DataTransfer')return 'Clipboard';if(name$==='FormData')return 'DOMFormData';return name$;};

$._WorkerEventsImpl$ = function(_ptr){return new $._WorkerEventsImpl(_ptr);};

$.ExceptionImplementation$ = function(msg){return new $.ExceptionImplementation(msg);};

$.sub$slow = function(a,b){if($.checkNumbers(a,b))return a - b;return a.operator$sub$1(b);};

$._maybeScheduleMeasurementFrame = function(){if($._nextMeasurementFrameScheduled===true)return;$._nextMeasurementFrameScheduled=true;if($._firstMeasurementRequest===true){$.add$1($.window().get$on().get$message(),new $._maybeScheduleMeasurementFrame_anon());$._firstMeasurementRequest=false;}$.window().postMessage$2('DART-MEASURE','*');};

$.AffineTransform$ = function(scaleX,shearY,shearX,scaleY,translateX,translateY){return new $.AffineTransform(scaleX,shearY,shearX,scaleY,translateX,translateY);};

$.typeNameInIE = function(obj){var name$=$.constructorNameFallback(obj);if(name$==='Window')return 'DOMWindow';if(name$==='Document'){if(!!obj.xmlVersion)return 'Document';return 'HTMLDocument';}if(name$==='CanvasPixelArray')return 'Uint8ClampedArray';if(name$==='DataTransfer')return 'Clipboard';if(name$==='DragEvent')return 'MouseEvent';if(name$==='HTMLDDElement')return 'HTMLElement';if(name$==='HTMLDTElement')return 'HTMLElement';if(name$==='HTMLTableDataCellElement')return 'HTMLTableCellElement';if(name$==='HTMLTableHeaderCellElement')return 'HTMLTableCellElement';if(name$==='HTMLPhraseElement')return 'HTMLElement';if(name$==='MSStyleCSSProperties')return 'CSSStyleDeclaration';if(name$==='MouseWheelEvent')return 'WheelEvent';if(name$==='FormData')return 'DOMFormData';return name$;};

$.CondorcetCandidateProfile$_internal = function(candidate,lostTo,beat,tied,TCandidate){var t1=new $.CondorcetCandidateProfile(candidate,lostTo,beat,tied);$.setRuntimeTypeInfo(t1,{ 'TCandidate': TCandidate });return t1;};

$.Primitives_newList = function(length$){if(length$==null)return new Array();if(!(typeof length$==='number'&&Math.floor(length$) === length$)||length$<0)throw $.$$throw($.IllegalArgumentException$(length$));var result=new Array(length$);result.fixed$length = true;return result;};

$.ge = function(a,b){return typeof a==='number'&&typeof b==='number'?a >= b:$.ge$slow(a,b);};

$._globalState = function(){return $globalState;};

$.substring$2 = function(receiver,startIndex,endIndex){if(!(typeof receiver==='string'))return receiver.substring$2(startIndex,endIndex);$.checkNum(startIndex);var length$=receiver.length;if(endIndex==null)endIndex=length$;$.checkNum(endIndex);if(startIndex<0)throw $.$$throw($.IndexOutOfRangeException$(startIndex));if($.gtB(startIndex,endIndex))throw $.$$throw($.IndexOutOfRangeException$(startIndex));if($.gtB(endIndex,length$))throw $.$$throw($.IndexOutOfRangeException$(endIndex));return $.substringUnchecked(receiver,startIndex,endIndex);};

$._globalState0 = function(val){$globalState = val;};

$.window = function(){return window;};

$.spawnFunction = function(topLevelFunction){var name$=$._IsolateNatives__getJSFunctionName(topLevelFunction);if(name$==null)throw $.$$throw($.UnsupportedOperationException$('only top-level functions can be spawned.'));return $._IsolateNatives__spawn(name$,null,false);};

$.HashMapImplementation$ = function(K,V){var t1=new $.HashMapImplementation(null,null,null,null,null);$.setRuntimeTypeInfo(t1,{ 'K': K, 'V': V });t1.HashMapImplementation$0();return t1;};

$._FixedSizeListIterator$ = function(array,T){var t1=new $._FixedSizeListIterator($.get$length(array),array,0);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$._FileReaderEventsImpl$ = function(_ptr){return new $._FileReaderEventsImpl(_ptr);};

$.DetailedIllegalArgumentException$ = function(arg,message){return new $.DetailedIllegalArgumentException(arg,message,'');};

$.PluralityElectionPlace$ = function(place,candidates,voteCount,TCandidate){var t1=new $.PluralityElectionPlace(voteCount,place,$.ListImplementation_List$from(candidates,$.getRuntimeTypeInfo(this).T));$.setRuntimeTypeInfo(t1,{ 'TCandidate': TCandidate });t1.ElectionPlace$2(place,candidates);t1.PluralityElectionPlace$3(place,candidates,voteCount);return t1;};

$.HashMapImplementation__nextProbe = function(currentProbe,numberOfProbes,length$){return $.and($.add(currentProbe,numberOfProbes),$.sub(length$,1));};

$._voterHexMapperIsolate = function(){$.port().receive$1(new $._voterHexMapperIsolate_anon());};

$._IsolateNatives__thisScript = function(){return $thisScriptUrl};

$.isInfinite = function(receiver){if(!(typeof receiver==='number'))return receiver.isInfinite$0();return receiver == Infinity||receiver == -Infinity;};

$.CompleterImpl$ = function(T){var t1=new $.CompleterImpl($.FutureImpl$());$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$.HashMapImplementation__computeLoadLimit = function(capacity){return $.tdiv(capacity*3,4);};

$._WindowEventsImpl$ = function(_ptr){return new $._WindowEventsImpl(_ptr);};

$._EventListenerListImpl$ = function(_ptr,_type){return new $._EventListenerListImpl(_ptr,_type);};

$.iae = function(argument){throw $.$$throw($.IllegalArgumentException$(argument));};

$._DOMApplicationCacheEventsImpl$ = function(_ptr){return new $._DOMApplicationCacheEventsImpl(_ptr);};

$._IsolateNatives__spawnWorker = function(functionName,uri,replyPort){if(functionName==null)functionName='main';if(uri==null)uri=$._IsolateNatives__thisScript();if($.Uri$fromString(uri).isAbsolute$0()!==true)uri=$.S($.substring$2($._IsolateNatives__thisScript(),0,$.lastIndexOf$1($._IsolateNatives__thisScript(),'/')))+'/'+$.S(uri);var worker=$._IsolateNatives__newWorker(uri);worker.set$onmessage(new $._IsolateNatives__spawnWorker_anon(worker));var t1=$._globalState();var workerId=t1.get$nextManagerId();t1.set$nextManagerId($.add(workerId,1));worker.set$id(workerId);$.indexSet($._globalState().get$managers(),workerId,worker);worker.postMessage$1($._serializeMessage($.makeLiteralMap(['command','start','id',workerId,'replyTo',$._serializeMessage(replyPort),'functionName',functionName])));};

$.toRadixString = function(receiver,radix){if(!(typeof receiver==='number'))return receiver.toRadixString$1(radix);$.checkNum(radix);return receiver.toString(radix);};

$.HslColor$_internal = function(h,s,l){return new $.HslColor(h,s,l);};

$.StringImplementation__toJsStringArray = function(strings){if(typeof strings!=='object'||strings===null||(strings.constructor!==Array||!!strings.immutable$list)&&!strings.is$JavaScriptIndexingBehavior())return $.StringImplementation__toJsStringArray$bailout(1,strings);$.checkNull(strings);var length$=strings.length;if($.isJsArray(strings)){for(var i=0;i<length$;++i){if(i<0||i>=strings.length)throw $.ioore(i);var string=strings[i];$.checkNull(string);if(!(typeof string==='string'))throw $.$$throw($.IllegalArgumentException$(string));}var array=strings;}else{array=$.ListImplementation_List(length$);for(i=0;i<length$;++i){if(i<0||i>=strings.length)throw $.ioore(i);string=strings[i];$.checkNull(string);if(!(typeof string==='string'))throw $.$$throw($.IllegalArgumentException$(string));if(i<0||i>=array.length)throw $.ioore(i);array[i]=string;}}return array;};

$.IllegalJSRegExpException$ = function(_pattern,_errmsg){return new $.IllegalJSRegExpException(_pattern,_errmsg);};

$._IsolateNatives__startIsolate = function(topLevel,replyTo){$._fillStatics($._globalState().get$currentContext());$._lazyPort=$._ReceivePortFactory_ReceivePort();replyTo.send$2('spawned',$.port().toSendPort$0());topLevel.call$0();};

$.split = function(receiver,pattern){if(!(typeof receiver==='string'))return receiver.split$1(pattern);$.checkNull(pattern);return $.stringSplitUnchecked(receiver,pattern);};

$._TarjanList__TarjanList = function(source,TNode){var map=$.HashMapImplementation$(TNode,'_TarjanNode<TNode>');var nodes=$.HashMapImplementation$('_TarjanNode<TNode>','HashSet<_TarjanNode<TNode>>');source.forEach$1(new $._TarjanList__TarjanList_anon(TNode,nodes,map));return $._TarjanList$_internal(nodes);};

$._timerFactory = function(millis,callback,repeating){return repeating===true?$._Timer$repeating(millis,callback):$._Timer$(millis,callback);};

$._DOMWindowCrossFrameImpl__top = function(win){return win.top;};

$.RootMapElement$ = function(w,h){var t1=$.AffineTransform$(1,0,0,1,0,0);t1=new $.RootMapElement($.VoterMapElement$(w,h),$.CandidateMapElement$(w,h),t1,$.EventHandle$('EventArgs'),null,null,null,$.ListImplementation_List(null,'AffineTransform'),false,$.EventHandle$('EventArgs'),$.EventHandle$('EventArgs'),null,w,h,null,null,false,null,$.PropertyValues$(),false);t1.RootMapElement$2(w,h);return t1;};

$.query = function(selector){return $._document().query$1(selector);};

$.VoteDemo$_internal = function(_canvas,_stage,_dragger,_rootMapElement,_condorcetView,_pluralityView,_distanceView,_canManView){var t1=$.HashMapImplementation$('MapPlayer','num');t1=new $.VoteDemo(_canvas,_stage,_dragger,$.CalcEngine$(),_rootMapElement,t1,_condorcetView,_distanceView,_pluralityView,_canManView,null,null,null,null,false);t1.VoteDemo$_internal$8(_canvas,_stage,_dragger,_rootMapElement,_condorcetView,_pluralityView,_distanceView,_canManView);return t1;};

$.constructorNameFallback = function(obj){var constructor$=obj.constructor;if(typeof(constructor$)==='function'){var name$=constructor$.name;if(typeof name$==='string')var t1=!(name$==='')&&!(name$==='Object')&&!(name$==='Function.prototype');else t1=false;if(t1)return name$;}var string=Object.prototype.toString.call(obj);return string.substring(8, string.length - 1);};

$.FormatException$ = function(message){return new $.FormatException(message);};

$.RgbColor__prependZeroIfNecessaryHelper = function(hex){return $.eqB($.get$length(hex),1)?$.concat('0',hex):hex;};

$.indexOf$1 = function(receiver,element){if($.isJsArray(receiver))return $.Arrays_indexOf(receiver,element,0,receiver.length);else if(typeof receiver==='string'){$.checkNull(element);if(!(typeof element==='string'))throw $.$$throw($.IllegalArgumentException$(element));return receiver.indexOf(element);}return receiver.indexOf$1(element);};

$.filter = function(receiver,predicate){if(!$.isJsArray(receiver))return receiver.filter$1(predicate);else return $.Collections_filter(receiver,[],predicate);};

$.Collections_filter = function(source,destination,f){for(var t1=$.iterator(source);t1.hasNext$0()===true;){var t2=t1.next$0();if(f.call$1(t2)===true)destination.push(t2);}return destination;};

$.FutureValueResult$ = function(value,TOutput){var t1=new $.FutureValueResult(value,null);$.setRuntimeTypeInfo(t1,{ 'TOutput': TOutput });return t1;};

$._Collections_filter = function(source,destination,f){for(var t1=$.iterator(source);t1.hasNext$0()===true;){var t2=t1.next$0();if(f.call$1(t2)===true)destination.push(t2);}return destination;};

$._ChildrenElementList$_wrap = function(element){return new $._ChildrenElementList(element,element.get$$$dom_children());};

$.unwrapException = function(ex){if("dartException" in ex)return ex.dartException;var message=ex.message;if(ex instanceof TypeError){var type=ex.type;var name$=ex.arguments ? ex.arguments[0] : "";if($.eqB(type,'property_not_function')||$.eqB(type,'called_non_callable')||$.eqB(type,'non_object_property_call')||$.eqB(type,'non_object_property_load'))if(typeof name$==='string'&&$.startsWith(name$,'call$')===true)return $.ObjectNotClosureException$();else return $.NullPointerException$(null,$.CTC10);else if($.eqB(type,'undefined_method'))if(typeof name$==='string'&&$.startsWith(name$,'call$')===true)return $.ObjectNotClosureException$();else return $.NoSuchMethodException$('',name$,[],null);var ieErrorCode=ex.number & 0xffff;var ieFacilityNumber=ex.number>>16 & 0x1FFF;if(typeof message==='string')if($.endsWith(message,'is null')===true||$.endsWith(message,'is undefined')===true||$.endsWith(message,'is null or undefined')===true)return $.NullPointerException$(null,$.CTC10);else{if($.contains$1(message,' is not a function')!==true)var t1=ieErrorCode===438&&ieFacilityNumber===10;else t1=true;if(t1)return $.NoSuchMethodException$('','<unknown>',[],null);}return $.ExceptionImplementation$(typeof message==='string'?message:'');}if(ex instanceof RangeError){if(typeof message==='string'&&$.contains$1(message,'call stack')===true)return $.StackOverflowException$();return $.IllegalArgumentException$('');}if(typeof InternalError == 'function' && ex instanceof InternalError)if(typeof message==='string'&&message==='too much recursion')return $.StackOverflowException$();return ex;};

$.Vector$ = function(x,y){return new $.Vector(x,y);};

$.LocationData_getHue = function(candidate){if($.LocationData__candidateHues==null)$.LocationData__candidateHues=$.LocationData__slice(26,360,3);var letterCode=$.sub($.charCodeAt(candidate.get$name(),0),65);return $.index($.LocationData__candidateHues,letterCode);};

$.checkNumbers = function(a,b){if(typeof a==='number')if(typeof b==='number')return true;else{$.checkNull(b);throw $.$$throw($.IllegalArgumentException$(b));}return false;};

$._ReceivePortImpl$ = function(){var t1=$._ReceivePortImpl__nextFreeId;$._ReceivePortImpl__nextFreeId=$.add(t1,1);t1=new $._ReceivePortImpl(t1,null);t1._ReceivePortImpl$0();return t1;};

$._NodeListWrapper$ = function(list){return new $._NodeListWrapper(list);};

$.stringJoinUnchecked = function(array,separator){return array.join(separator);};

$._WorkerSendPort$ = function(_workerId,isolateId,_receivePortId){return new $._WorkerSendPort(_workerId,_receivePortId,isolateId);};

$.TarjanCycleDetect_getStronglyConnectedComponents = function(graph){return $.TarjanCycleDetect$_internal($._TarjanList__TarjanList(graph))._executeTarjan$0();};

$.checkString = function(value){if(!(typeof value==='string')){$.checkNull(value);throw $.$$throw($.IllegalArgumentException$(value));}return value;};

$._DataAttributeMap$ = function($$dom_attributes){return new $._DataAttributeMap($$dom_attributes);};

$.Arrays_indexOf = function(a,element,startIndex,endIndex){if(typeof a!=='string'&&(typeof a!=='object'||a===null||a.constructor!==Array&&!a.is$JavaScriptIndexingBehavior()))return $.Arrays_indexOf$bailout(1,a,element,startIndex,endIndex);if(startIndex>=a.length)return -1;if(startIndex<0)startIndex=0;for(var i=startIndex;i<endIndex;++i){if(i<0||i>=a.length)throw $.ioore(i);if($.eqB(a[i],element))return i;}return -1;};

$._Lists_indexOf = function(a,element,startIndex,endIndex){if(typeof a!=='string'&&(typeof a!=='object'||a===null||a.constructor!==Array&&!a.is$JavaScriptIndexingBehavior()))return $._Lists_indexOf$bailout(1,a,element,startIndex,endIndex);if(typeof endIndex!=='number')return $._Lists_indexOf$bailout(1,a,element,startIndex,endIndex);if(startIndex>=a.length)return -1;if(startIndex<0)startIndex=0;for(var i=startIndex;i<endIndex;++i){if(i<0||i>=a.length)throw $.ioore(i);if($.eqB(a[i],element))return i;}return -1;};

$._WhereIterator$ = function(_source,_func,T){var t1=new $._WhereIterator(_source,_func,null,null);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$._Device_isOpera = function(){return $.contains$2($._Device_userAgent(),'Opera',0);};

$.FutureValueResult_FutureValueResult$fromMap = function(value,TOutput){$.requireArgumentNotNull(value,'value');$.requireArgument($.FutureValueResult_isMyMap(value),'value',null);var ex=$.index(value,'exception');if(!(ex==null))return $.FutureValueResult$fromException(ex);else return $.FutureValueResult$($.index(value,'value'));};

$._ElementFactoryProvider_Element$tag = function(tag){return document.createElement(tag)};

$._SimpleClientRect$ = function(left,top$,width,height){return new $._SimpleClientRect(left,top$,width,height);};

$._DistanceElectionMapper$ = function(){return new $._DistanceElectionMapper($.spawnFunction($._distanceElectionIsolate),null,null,null,null,null,false,$.EventHandle$('EventArgs'),$.EventHandle$('EventArgs'),$.EventHandle$('Object'));};

$.ReadOnlyCollection$empty = function(T){var t1=new $.ReadOnlyCollection($.CTC10);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$.requireArgumentNotNull = function(argument,argName){if(argument==null)throw $.$$throw($.NullArgumentException$(argName));};

$._LocationWrapper$ = function(_ptr){return new $._LocationWrapper(_ptr);};

$._FuncEnumerable$ = function(_source,_func,TSource,TOutput){var t1=new $._FuncEnumerable(_source,_func);$.setRuntimeTypeInfo(t1,{ 'TSource': TSource, 'TOutput': TOutput });return t1;};

$.Stage$ = function(_canvas,_element){var t1=new $.Stage(_canvas,_element,$.EventHandle$('EventArgs'),null,$.PropertyValues$(),false);t1.Stage$2(_canvas,_element);return t1;};

$.contains = function(userAgent,name$){return !(userAgent.indexOf(name$)===-1);};

$._TextTrackCueEventsImpl$ = function(_ptr){return new $._TextTrackCueEventsImpl(_ptr);};

$.RgbColor__validateComponent = function(c,name$){$.requireArgument(!(c==null)&&$.isInfinite(c)!==true&&$.isNaN(c)!==true,name$,null);$.requireArgument($.geB(c,0)&&$.leB(c,255),name$,null);};

$.Random_Random = function(seed){return $.CTC23;};

$.regExpExec = function(regExp,str){var result=$.regExpGetNative(regExp).exec(str);if(result === null)return;return result;};

$.endsWith = function(receiver,other){$.checkString(other);var receiverLength=receiver.length;var otherLength=other.length;if(otherLength>receiverLength)return false;return other===$.substring$1(receiver,receiverLength-otherLength);};

$.ReadOnlyCollection$wrap = function(source,T){var t1=new $.ReadOnlyCollection(source);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$._SpeechRecognitionEventsImpl$ = function(_ptr){return new $._SpeechRecognitionEventsImpl(_ptr);};

$.Util_getHashCode = function(source){for(var t1=$.iterator(source),hash=0;t1.hasNext$0()===true;){var t2=t1.next$0();var next=t2==null?0:$.hashCode(t2);if(typeof next!=='number')throw $.iae(next);var hash0=536870911&hash+next;var hash1=536870911&hash0+((524287&hash0)<<10>>>0);hash1=(hash1^$.shr(hash1,6))>>>0;hash=hash1;}hash0=536870911&hash+((67108863&hash)<<3>>>0);hash0=(hash0^$.shr(hash0,11))>>>0;return 536870911&hash0+((16383&hash0)<<15>>>0);};

$.IllegalArgumentException$ = function(arg){return new $.IllegalArgumentException(arg);};

$._IsolateNatives__startWorker = function(functionName,uri,replyPort){if($._globalState().get$isWorker()===true)$._globalState().get$mainManager().postMessage$1($._serializeMessage($.makeLiteralMap(['command','spawn-worker','functionName',functionName,'uri',uri,'replyPort',replyPort])));else $._IsolateNatives__spawnWorker(functionName,uri,replyPort);};

$.MapPlayer$ = function(_location,name$){return new $.MapPlayer($.GlobalId_GlobalId(),name$,_location);};

$.stringLastIndexOfUnchecked = function(receiver,element,start){return receiver.lastIndexOf(element, start);};

$._CondorcetElectionMapper$ = function(){return new $._CondorcetElectionMapper($.spawnFunction($._condorcetElectionIsolate),null,null,null,null,null,false,$.EventHandle$('EventArgs'),$.EventHandle$('EventArgs'),$.EventHandle$('Object'));};

$._HttpRequestUploadEventsImpl$ = function(_ptr){return new $._HttpRequestUploadEventsImpl(_ptr);};

$.Mouse_markMouseOver = function(stage,coordinate){$.requireArgumentNotNull(stage,'stage');var t1=!(coordinate==null);$.requireArgument(coordinate==null||coordinate.get$isValid()===true,'coordinate',null);var items=$.CTC25.get$1(stage);if(!(items==null)){$.forEach(items,new $.Mouse_markMouseOver_anon());$.CTC25.clear$1(stage);}if(t1){var hits=$.RetainedUtil_hitTest(stage,coordinate);$.CTC25.set$2(stage,hits);$.forEach(hits,new $.Mouse_markMouseOver_anon0());if($.gtB($.get$length(hits),0))$.CTC26.set$2($.index(hits,0),true);return hits;}return;};

$.DualPivotQuicksort__doSort = function(a,left,right,compare){if($.leB($.sub(right,left),32))$.DualPivotQuicksort_insertionSort_(a,left,right,compare);else $.DualPivotQuicksort__dualPivotQuicksort(a,left,right,compare);};

$.PluralityView$ = function(node){var t1=new $.PluralityView(null,node,null);t1.HtmlView$1(node);return t1;};

$.checkNull = function(object){if(object==null)throw $.$$throw($.NullPointerException$(null,$.CTC10));return object;};

$.DistanceElectionPlace$ = function(place,candidates,avgDistance,avgDistanceSquared,TCandidate){var t1=new $.DistanceElectionPlace(avgDistance,avgDistanceSquared,place,$.ListImplementation_List$from(candidates,$.getRuntimeTypeInfo(this).T));$.setRuntimeTypeInfo(t1,{ 'TCandidate': TCandidate });t1.ElectionPlace$2(place,candidates);return t1;};

$.CondorcetView$ = function(node){var t1=new $.CondorcetView($.EventHandle$('EventArgs'),null,null,null,node,null);t1.HtmlView$1(node);return t1;};

$.DistanceElection$_internal = function(candidates,ballots,places,TVoter,TCandidate){var t1=new $.DistanceElection(candidates,ballots,places);$.setRuntimeTypeInfo(t1,{ 'TVoter': TVoter, 'TCandidate': TCandidate });return t1;};

$._MeasurementRequest$ = function(computeValue,completer,T){var t1=new $._MeasurementRequest(computeValue,completer,null,false);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$.Collections__containsRef = function(c,ref){for(var t1=$.iterator(c);t1.hasNext$0()===true;){var t2=t1.next$0();if(t2==null?ref==null:t2===ref)return true;}return false;};

$._MediaElementEventsImpl$ = function(_ptr){return new $._MediaElementEventsImpl(_ptr);};

$._Lists_lastIndexOf = function(a,element,startIndex){if(typeof a!=='string'&&(typeof a!=='object'||a===null||a.constructor!==Array&&!a.is$JavaScriptIndexingBehavior()))return $._Lists_lastIndexOf$bailout(1,a,element,startIndex);if(typeof startIndex!=='number')return $._Lists_lastIndexOf$bailout(1,a,element,startIndex);if(startIndex<0)return -1;var t1=a.length;if(startIndex>=t1)startIndex=t1-1;for(var i=startIndex;i>=0;--i){if(i!==(i|0))throw $.iae(i);if(i<0||i>=a.length)throw $.ioore(i);if($.eqB(a[i],element))return i;}return -1;};

$.getTraceFromException = function(exception){return $.StackTrace$(exception.stack);};

$.concat = function(receiver,other){if(!(typeof other==='string'))throw $.$$throw($.IllegalArgumentException$(other));return receiver + other;};

$.Maps__emitMap = function(m,result,visiting){var t1={};$.add$1(visiting,m);$.add$1(result,'{');t1.first_1=true;$.forEach(m,new $.Maps__emitMap_anon(result,t1,visiting));$.add$1(result,'}');$.removeLast(visiting);};

$._MessageTraverser_isPrimitive = function(x){return x==null||typeof x==='string'||typeof x==='number'||typeof x==='boolean';};

$._Deserializer_isPrimitive = function(x){return x==null||typeof x==='string'||typeof x==='number'||typeof x==='boolean';};

$.propertySet = function(object,property,value){object[property] = value;};

$.CanvasUtil_transform = function(ctx,tx){$.requireArgumentNotNull(ctx,'ctx');$.requireArgumentNotNull(tx,'tx');ctx.transform$6(tx.get$scaleX(),tx.get$shearY(),tx.get$shearX(),tx.get$scaleY(),tx.get$translateX(),tx.get$translateY());};

$._BatteryManagerEventsImpl$ = function(_ptr){return new $._BatteryManagerEventsImpl(_ptr);};

$._IDBOpenDBRequestEventsImpl$ = function(_ptr){return new $._IDBOpenDBRequestEventsImpl(_ptr);};

$.sqrt = function(value){return Math.sqrt($.checkNum(value));};

$.LocationData_LocationData$random = function(){var voters=$.ListImplementation_List(null,'MapPlayer');for(var i=0;i<20;++i)for(var t1=i*1.0526315789473684,j=0;j<20;++j)voters.push($.MapPlayer$($.Coordinate$(t1,j*1.0526315789473684),null));var coords=$.ListImplementation_List(null,'Vector');var middle=$.Vector$(0.5,0.5);coords.push(middle);for(i=0;i<4;++i){var coord=$.Vector$($.rnd().nextDouble$0(),$.rnd().nextDouble$0());coords.push(coord);}var candidates=$.ListImplementation_List(null,'MapPlayer');$.$$(coords).select$1(new $.LocationData_LocationData$random_anon()).forEachWithIndex$1(new $.LocationData_LocationData$random_anon0(candidates));return $.LocationData$($.ReadOnlyCollection$wrap(voters,'MapPlayer'),$.ReadOnlyCollection$wrap(candidates,'MapPlayer'));};

$.checkGrowable = function(list,reason){if(!!(list.fixed$length))throw $.$$throw($.UnsupportedOperationException$(reason));};

$._serializeMessage = function(message){if($._globalState().get$needSerialization()===true)return $._JsSerializer$().traverse$1(message);else return $._JsCopier$().traverse$1(message);};

$.Rect$ = function(left,top$,width,height){return new $.Rect(left,top$,width,height);};

$._IsolateNatives__consoleLog = function(msg){$globalThis.console.log(msg);};

$.IndexOutOfRangeException$ = function(_value){return new $.IndexOutOfRangeException(_value);};

$.KeyValuePair$ = function(key,value,K,V){var t1=new $.KeyValuePair(key,value);$.setRuntimeTypeInfo(t1,{ 'K': K, 'V': V });return t1;};

$._DocumentEventsImpl$ = function(_ptr){return new $._DocumentEventsImpl(_ptr);};

$.CandidateManagerView$ = function(node){var t1=new $.CandidateManagerView($.EventHandle$('MapPlayer'),$.EventHandle$('EventArgs'),$.ReadOnlyCollection$empty('MapPlayer'),node,null);t1.HtmlView$1(node);return t1;};

$.Mouse_isMouseDirectlyOver = function(element){return $.CTC26.get$1(element);};

$._IDBVersionChangeRequestEventsImpl$ = function(_ptr){return new $._IDBVersionChangeRequestEventsImpl(_ptr);};

$._MessageTraverserVisitedMap$ = function(){return new $._MessageTraverserVisitedMap();};

$.NullArgumentException$ = function(arg){return new $.NullArgumentException(arg,arg);};

$.FutureNotCompleteException$ = function(){return new $.FutureNotCompleteException();};

$._JsSerializer$ = function(){var t1=new $._JsSerializer(0,$._MessageTraverserVisitedMap$());t1._JsSerializer$0();return t1;};

$.CancelableEventArgs$ = function(){return new $.CancelableEventArgs(false);};

$.LinkedHashMapImplementation$ = function(K,V){var t1=new $.LinkedHashMapImplementation(null,null);$.setRuntimeTypeInfo(t1,{ 'K': K, 'V': V });t1.LinkedHashMapImplementation$0();return t1;};

$.FutureImpl$ = function(T){var t1=new $.FutureImpl(false,null,null,null,false,[],[],[]);$.setRuntimeTypeInfo(t1,{ 'T': T });return t1;};

$.toString = function(value){if(typeof value == "object" && value !== null)if($.isJsArray(value))return $.Collections_collectionToString(value);else return value.toString$0();if(value === 0 && (1 / value) < 0)return '-0.0';if(value==null)return 'null';if(typeof value == "function")return 'Closure';return String(value);};

$._DOMWindowCrossFrameImpl__createSafe = function(w){var t1=$.window();if(w==null?t1==null:w===t1)return w;else return $._DOMWindowCrossFrameImpl$(w);};

$.HslColor_HslColor = function(h,s,l){$.requireArgument(!(h==null)&&$.isInfinite(h)!==true&&$.isNaN(h)!==true,'h',null);h=$.mod(h,360);$.requireArgument($.isInfinite(s)!==true&&$.isNaN(s)!==true,'s','must be a valid number');var t1=s>=0&&s<=1;$.requireArgument(t1,'s','must be >= 0 && <= 1 but was '+$.S(s));$.requireArgument($.isInfinite(l)!==true&&$.isNaN(l)!==true,'l','must be a valid number');t1=l>=0&&l<=1;$.requireArgument(t1,'l','must be >= 0 && <=1 but was '+$.S(l));return $.HslColor$_internal(h,s,l);};

$.defineProperty = function(obj,property,value){Object.defineProperty(obj, property,
      {value: value, enumerable: false, writable: true, configurable: true});};

$.lt = function(a,b){return typeof a==='number'&&typeof b==='number'?a < b:$.lt$slow(a,b);};

$._FileWriterEventsImpl$ = function(_ptr){return new $._FileWriterEventsImpl(_ptr);};

$._Manager$ = function(){var t1=new $._Manager(0,0,1,null,null,null,null,null,null,null,null,null);t1._Manager$0();return t1;};

$.regExpGetNative = function(regExp){var r=regExp._re;return r==null?regExp._re = $.regExpMakeNative(regExp,false):r;};

$.sub = function(a,b){return typeof a==='number'&&typeof b==='number'?a - b:$.sub$slow(a,b);};

$._Lists_lastIndexOf$bailout = function(state,a,element,startIndex){if($.ltB(startIndex,0))return -1;if($.geB(startIndex,$.get$length(a)))startIndex=$.sub($.get$length(a),1);for(var i=startIndex;$.geB(i,0);i=$.sub(i,1))if($.eqB($.index(a,i),element))return i;return -1;};

$.Arrays_lastIndexOf$bailout = function(state,a,element,startIndex){if($.ltB(startIndex,0))return -1;if($.geB(startIndex,$.get$length(a)))startIndex=$.sub($.get$length(a),1);for(var i=startIndex;$.geB(i,0);i=$.sub(i,1))if($.eqB($.index(a,i),element))return i;return -1;};

$.Arrays_indexOf$bailout = function(state,a,element,startIndex,endIndex){if($.geB(startIndex,$.get$length(a)))return -1;if(startIndex<0)startIndex=0;for(var i=startIndex;i<endIndex;++i)if($.eqB($.index(a,i),element))return i;return -1;};

$._Lists_indexOf$bailout = function(state,a,element,startIndex,endIndex){if($.geB(startIndex,$.get$length(a)))return -1;if(startIndex<0)startIndex=0;for(var i=startIndex;$.ltB(i,endIndex);++i)if($.eqB($.index(a,i),element))return i;return -1;};

$._Lists_getRange$bailout = function(state,a,start,length$,accumulator){if($.ltB(length$,0))throw $.$$throw($.IllegalArgumentException$('length'));if($.ltB(start,0))throw $.$$throw($.IndexOutOfRangeException$(start));var end=$.add(start,length$);if($.gtB(end,$.get$length(a)))throw $.$$throw($.IndexOutOfRangeException$(end));for(var i=start;$.ltB(i,end);i=$.add(i,1))accumulator.push($.index(a,i));return accumulator;};

$.DualPivotQuicksort__dualPivotQuicksort$bailout = function(state,env0,env1,env2,env3,env4,env5,env6,env7,env8,env9,env10,env11,env12,env13){switch(state){case 1:var a=env0;var left=env1;var right=env2;var compare=env3;break;case 2:a=env0;left=env1;compare=env2;less=env3;k=env4;index1=env5;index5=env6;el2=env7;pivots_are_equal=env8;right=env9;ak=env10;comp=env11;el4=env12;great=env13;break;}switch(state){case 0:case 1:state=0;var sixth=$.tdiv($.add($.sub(right,left),1),6);if(typeof sixth!=='number')throw $.iae(sixth);var index1=left+sixth;var index5=$.sub(right,sixth);if(typeof right!=='number')throw $.iae(right);var index3=$.tdiv(left+right,2);var index2=index3-sixth;var index4=index3+sixth;var el1=$.index(a,index1);var el2=$.index(a,index2);var el3=$.index(a,index3);var el4=$.index(a,index4);var el5=$.index(a,index5);if($.gtB(compare.call$2(el1,el2),0)){var t0=el1;el1=el2;el2=t0;}if($.gtB(compare.call$2(el4,el5),0)){t0=el5;el5=el4;el4=t0;}if($.gtB(compare.call$2(el1,el3),0)){t0=el3;el3=el1;el1=t0;}if($.gtB(compare.call$2(el2,el3),0)){t0=el3;el3=el2;el2=t0;}if($.gtB(compare.call$2(el1,el4),0)){t0=el1;el1=el4;el4=t0;}if($.gtB(compare.call$2(el3,el4),0)){t0=el3;el3=el4;el4=t0;}if($.gtB(compare.call$2(el2,el5),0)){t0=el5;el5=el2;el2=t0;}if($.gtB(compare.call$2(el2,el3),0)){t0=el3;el3=el2;el2=t0;}if($.gtB(compare.call$2(el4,el5),0)){t0=el5;el5=el4;el4=t0;}$.indexSet(a,index1,el1);$.indexSet(a,index3,el3);$.indexSet(a,index5,el5);$.indexSet(a,index2,$.index(a,left));$.indexSet(a,index4,$.index(a,right));var less=left+1;var great=right-1;var pivots_are_equal=$.eqB(compare.call$2(el2,el4),0);case 2:if(state===2||state===0&&pivots_are_equal)switch(state){case 0:var k=less;case 2:L0:while(true)switch(state){case 0:if(!(k<=great))break L0;case 2:c$0:{switch(state){case 0:var ak=$.index(a,k);var comp=compare.call$2(ak,el2);case 2:state=0;if($.eqB(comp,0))break c$0;if($.ltB(comp,0)){if(!(k===less)){$.indexSet(a,k,$.index(a,less));$.indexSet(a,less,ak);}++less;}else for(var less0=less+1;true;){comp=compare.call$2($.index(a,great),el2);if($.gtB(comp,0)){--great;continue;}else if($.ltB(comp,0)){$.indexSet(a,k,$.index(a,less));$.indexSet(a,less,$.index(a,great));var great0=great-1;$.indexSet(a,great,ak);great=great0;less=less0;break;}else{$.indexSet(a,k,$.index(a,great));great0=great-1;$.indexSet(a,great,ak);great=great0;break;}}}}++k;}}else for(k=less;k<=great;++k){ak=$.index(a,k);if($.ltB(compare.call$2(ak,el2),0)){if(!(k===less)){$.indexSet(a,k,$.index(a,less));$.indexSet(a,less,ak);}++less;}else if($.gtB(compare.call$2(ak,el4),0))for(less0=less+1;true;)if($.gtB(compare.call$2($.index(a,great),el4),0)){--great;if(great<k)break;continue;}else{if($.ltB(compare.call$2($.index(a,great),el2),0)){$.indexSet(a,k,$.index(a,less));$.indexSet(a,less,$.index(a,great));great0=great-1;$.indexSet(a,great,ak);great=great0;less=less0;}else{$.indexSet(a,k,$.index(a,great));great0=great-1;$.indexSet(a,great,ak);great=great0;}break;}}var t1=less-1;$.indexSet(a,left,$.index(a,t1));$.indexSet(a,t1,el2);$.indexSet(a,right,$.index(a,great+1));$.indexSet(a,great+1,el4);$.DualPivotQuicksort__doSort(a,left,less-2,compare);$.DualPivotQuicksort__doSort(a,great+2,right,compare);if(pivots_are_equal)return;if(less<index1&&$.gtB(great,index5)){for(;$.eqB(compare.call$2($.index(a,less),el2),0);)++less;for(;$.eqB(compare.call$2($.index(a,great),el4),0);)--great;for(k=less;k<=great;++k){ak=$.index(a,k);if($.eqB(compare.call$2(ak,el2),0)){if(!(k===less)){$.indexSet(a,k,$.index(a,less));$.indexSet(a,less,ak);}++less;}else if($.eqB(compare.call$2(ak,el4),0))for(less0=less+1;true;)if($.eqB(compare.call$2($.index(a,great),el4),0)){--great;if(great<k)break;continue;}else{if($.ltB(compare.call$2($.index(a,great),el2),0)){$.indexSet(a,k,$.index(a,less));$.indexSet(a,less,$.index(a,great));great0=great-1;$.indexSet(a,great,ak);great=great0;less=less0;}else{$.indexSet(a,k,$.index(a,great));great0=great-1;$.indexSet(a,great,ak);great=great0;}break;}}$.DualPivotQuicksort__doSort(a,less,great,compare);}else $.DualPivotQuicksort__doSort(a,less,great,compare);}};

$.RetainedUtil__hitTest$bailout = function(state,env0,env1,env2,env3){switch(state){case 1:var element=env0;length$=env1;point=env2;hits=env3;break;}switch(state){case 0:var point=$.RetainedUtil_transformPointGlobalToLocal(element,point);var bounds=$.Rect$(0,0,element.get$width(),element.get$height());var hits=$.ListImplementation_List(null,'PElement');case 1:if(state===1||state===0&&bounds.contains$1(point)===true)switch(state){case 0:var length$=element.get$visualChildCount();case 1:state=0;for(var i=0;$.ltB(i,length$);++i){hits=$.RetainedUtil__hitTest(element.getVisualChild$1($.sub($.sub(length$,1),i)),point);if(hits.length>0)break;}hits.push(element);return hits;}else return [];}};

$.Futures_wait$bailout = function(state,futures,t1){if($.isEmpty(futures)===true)return $.FutureImpl_FutureImpl$immediate($.CTC10,'List');var completer=$.CompleterImpl$('List');var result=completer.get$future();t1.remaining_1=$.get$length(futures);var values=$.ListImplementation_List($.get$length(futures));for(var i=0;$.ltB(i,$.get$length(futures));++i){var future=$.index(futures,i);future.then$1(new $.Futures_wait_anon(completer,i,t1,result,values));future.handleException$1(new $.Futures_wait_anon0(future,completer,result));}return result;};

$.Arrays_copy$bailout = function(state,src,srcStart,dst,dstStart,count){if(srcStart<dstStart)for(var i=srcStart+count-1,j=dstStart+count-1;i>=srcStart;--i,--j)$.indexSet(dst,j,$.index(src,i));else for(var t1=srcStart+count,i=srcStart,j=dstStart;i<t1;++i,++j)$.indexSet(dst,j,$.index(src,i));};

$.StringImplementation__toJsStringArray$bailout = function(state,strings){$.checkNull(strings);var length$=$.get$length(strings);if($.isJsArray(strings)){for(var i=0;$.ltB(i,length$);++i){var string=$.index(strings,i);$.checkNull(string);if(!(typeof string==='string'))throw $.$$throw($.IllegalArgumentException$(string));}var array=strings;}else{array=$.ListImplementation_List(length$);for(i=0;$.ltB(i,length$);++i){string=$.index(strings,i);$.checkNull(string);if(!(typeof string==='string'))throw $.$$throw($.IllegalArgumentException$(string));if(i<0||i>=array.length)throw $.ioore(i);array[i]=string;}}return array;};

$.CollectionUtil_allUnique$bailout = function(state,items){$.requireArgumentNotNull(items,'items');for(var i=0;$.ltB(i,$.get$length(items));++i)for(var j=i+1;$.ltB(j,$.get$length(items));++j)if($.eqB($.index(items,i),$.index(items,j)))return false;return true;};

$.listInsertRange$bailout = function(state,receiver,start,length$,initialValue){if(length$===0)return;$.checkNull(start);$.checkNull(length$);if(length$<0)throw $.$$throw($.IllegalArgumentException$(length$));var receiverLength=receiver.length;if(start<0||start>receiverLength)throw $.$$throw($.IndexOutOfRangeException$(start));var t1=receiverLength+length$;$.set$length(receiver,t1);var t2=start+length$;$.Arrays_copy(receiver,start,receiver,t2,receiverLength-start);if(!(initialValue==null))for(var i=start;i<t2;++i)$.indexSet(receiver,i,initialValue);$.set$length(receiver,t1);};

$.DualPivotQuicksort_insertionSort_$bailout = function(state,a,left,right,compare){for(var i=left+1;$.leB(i,right);++i){var el=$.index(a,i);var j=i;while(true){if(!(j>left&&$.gtB(compare.call$2($.index(a,j-1),el),0)))break;var j0=j-1;$.indexSet(a,j,$.index(a,j0));j=j0;}$.indexSet(a,j,el);}};

$.toStringWrapper.call$0 = $.toStringWrapper;
$.toStringWrapper.$name = "toStringWrapper";
$._condorcetElectionIsolate.call$0 = $._condorcetElectionIsolate;
$._condorcetElectionIsolate.$name = "_condorcetElectionIsolate";
$.constructorNameFallback.call$1 = $.constructorNameFallback;
$.constructorNameFallback.$name = "constructorNameFallback";
$._voterHexMapperIsolate.call$0 = $._voterHexMapperIsolate;
$._voterHexMapperIsolate.$name = "_voterHexMapperIsolate";
$.typeNameInIE.call$1 = $.typeNameInIE;
$.typeNameInIE.$name = "typeNameInIE";
$._distanceElectionIsolate.call$0 = $._distanceElectionIsolate;
$._distanceElectionIsolate.$name = "_distanceElectionIsolate";
$.dynamicBind.call$4 = $.dynamicBind;
$.dynamicBind.$name = "dynamicBind";
$.typeNameInFirefox.call$1 = $.typeNameInFirefox;
$.typeNameInFirefox.$name = "typeNameInFirefox";
$.typeNameInSafari.call$1 = $.typeNameInSafari;
$.typeNameInSafari.$name = "typeNameInSafari";
$.typeNameInChrome.call$1 = $.typeNameInChrome;
$.typeNameInChrome.$name = "typeNameInChrome";
$.typeNameInOpera.call$1 = $.typeNameInOpera;
$.typeNameInOpera.$name = "typeNameInOpera";
$.invokeClosure.call$5 = $.invokeClosure;
$.invokeClosure.$name = "invokeClosure";
$._pluralityElectionIsolate.call$0 = $._pluralityElectionIsolate;
$._pluralityElectionIsolate.$name = "_pluralityElectionIsolate";
$._timerFactory.call$3 = $._timerFactory;
$._timerFactory.$name = "_timerFactory";
Isolate.$finishClasses($$);
$$ = {};
Isolate.makeConstantList = function(list) {
  list.immutable$list = true;
  list.fixed$length = true;
  return list;
};
$.CTC10 = Isolate.makeConstantList([]);
$.CTC11 = new Isolate.$isolateProperties.NoMoreElementsException();
$.CTC43 = 'Cannot removeLast on immutable List.';
$.CTC12 = new Isolate.$isolateProperties.UnsupportedOperationException('Cannot removeLast on immutable List.');
$.CTC34 = new Isolate.$isolateProperties.ConstantMap(0, {}, Isolate.$isolateProperties.CTC10);
$.CTC44 = false;
$.CTC45 = '^#[_a-zA-Z]\\w*$';
$.CTC = new Isolate.$isolateProperties.JSSyntaxRegExp(false, false, '^#[_a-zA-Z]\\w*$');
$.CTC46 = 'structured clone of File';
$.CTC4 = new Isolate.$isolateProperties.NotImplementedException('structured clone of File');
$.CTC47 = '';
$.CTC36 = new Isolate.$isolateProperties.UnsupportedOperationException('');
$.CTC48 = 'structured clone of other type';
$.CTC9 = new Isolate.$isolateProperties.NotImplementedException('structured clone of other type');
$.CTC49 = null;
$.CTC38 = new Isolate.$isolateProperties.NotImplementedException(null);
$.CTC50 = 'The input sequence contains more than one element.';
$.CTC31 = new Isolate.$isolateProperties.InvalidOperationException('The input sequence contains more than one element.');
$.CTC51 = 'Mutation operations are not supported';
$.CTC18 = new Isolate.$isolateProperties.UnsupportedOperationException('Mutation operations are not supported');
$.CTC14 = new Isolate.$isolateProperties.EmptyQueueException();
$.CTC13 = new Isolate.$isolateProperties._DeletedKeySentinel();
$.CTC52 = 'IsMouseOver';
$.CTC28 = new Isolate.$isolateProperties.Property(false, 'IsMouseOver');
$.CTC53 = 'Invalid list length';
$.CTC39 = new Isolate.$isolateProperties.IllegalArgumentException('Invalid list length');
$.CTC54 = 'IsMouseDirectlyOver';
$.CTC26 = new Isolate.$isolateProperties.Property(false, 'IsMouseDirectlyOver');
$.CTC42 = new Isolate.$isolateProperties.Object();
$.CTC55 = 'structured clone of FileList';
$.CTC6 = new Isolate.$isolateProperties.NotImplementedException('structured clone of FileList');
$.CTC56 = 'structured clone of RegExp';
$.CTC3 = new Isolate.$isolateProperties.NotImplementedException('structured clone of RegExp');
$.CTC57 = 'offsetX is only supported on elements';
$.CTC29 = new Isolate.$isolateProperties.UnsupportedOperationException('offsetX is only supported on elements');
$.CTC58 = 'Cannot removeRange on immutable List.';
$.CTC17 = new Isolate.$isolateProperties.UnsupportedOperationException('Cannot removeRange on immutable List.');
$.CTC59 = 'structured clone of Blob';
$.CTC5 = new Isolate.$isolateProperties.NotImplementedException('structured clone of Blob');
$.CTC24 = new Isolate.$isolateProperties.EventArgs();
$.CTC60 = 'Cannot insertRange on immutable List.';
$.CTC20 = new Isolate.$isolateProperties.UnsupportedOperationException('Cannot insertRange on immutable List.');
$.CTC61 = 0;
$.CTC62 = new Isolate.$isolateProperties.Coordinate(0, 0);
$.CTC63 = 20;
$.CTC30 = new Isolate.$isolateProperties.Rect(0, 0, 20, 20);
$.CTC64 = 'Cannot add to immutable List.';
$.CTC1 = new Isolate.$isolateProperties.UnsupportedOperationException('Cannot add to immutable List.');
$.CTC65 = 'IDBKey containing Date';
$.CTC15 = new Isolate.$isolateProperties.NotImplementedException('IDBKey containing Date');
$.CTC66 = 'The input sequence is empty.';
$.CTC21 = new Isolate.$isolateProperties.InvalidOperationException('The input sequence is empty.');
$.CTC67 = 'structured clone of Date';
$.CTC2 = new Isolate.$isolateProperties.NotImplementedException('structured clone of Date');
$.CTC23 = new Isolate.$isolateProperties._Random();
$.CTC68 = 'TODO(jacobr): should we impl?';
$.CTC37 = new Isolate.$isolateProperties.UnsupportedOperationException('TODO(jacobr): should we impl?');
$.CTC69 = '_stageMouseCacheProperty';
$.CTC25 = new Isolate.$isolateProperties.Property(null, '_stageMouseCacheProperty');
$.CTC70 = new Isolate.$isolateProperties._SimpleClientRect(0, 0, 0, 0);
$.CTC32 = new Isolate.$isolateProperties.EmptyElementRect(Isolate.$isolateProperties.CTC70, Isolate.$isolateProperties.CTC70, Isolate.$isolateProperties.CTC70, Isolate.$isolateProperties.CTC70, Isolate.$isolateProperties.CTC10);
$.CTC71 = 'frozen class set cannot be modified';
$.CTC33 = new Isolate.$isolateProperties.UnsupportedOperationException('frozen class set cannot be modified');
$.CTC72 = 'Cannot sort immutable List.';
$.CTC22 = new Isolate.$isolateProperties.UnsupportedOperationException('Cannot sort immutable List.');
$.CTC73 = 'structured clone of ArrayBuffer';
$.CTC7 = new Isolate.$isolateProperties.NotImplementedException('structured clone of ArrayBuffer');
$.CTC27 = new Isolate.$isolateProperties._UndefinedValue();
$.CTC35 = new Isolate.$isolateProperties.IllegalAccessException();
$.CTC74 = 'must be implemented by subclass';
$.CTC19 = new Isolate.$isolateProperties.NotImplementedException('must be implemented by subclass');
$.CTC75 = '^\\[name=["\'][^\'"]+[\'"]\\]$';
$.CTC40 = new Isolate.$isolateProperties.JSSyntaxRegExp(false, false, '^\\[name=["\'][^\'"]+[\'"]\\]$');
$.CTC76 = '^(?:([^:/?#.]+):)?(?://(?:([^/?#]*)@)?([\\w\\d\\-\\u0100-\\uffff.%]*)(?::([0-9]+))?)?([^?#]+)?(?:\\?([^#]*))?(?:#(.*))?$';
$.CTC16 = new Isolate.$isolateProperties.JSSyntaxRegExp(false, false, '^(?:([^:/?#.]+):)?(?://(?:([^/?#]*)@)?([\\w\\d\\-\\u0100-\\uffff.%]*)(?::([0-9]+))?)?([^?#]+)?(?:\\?([^#]*))?(?:#(.*))?$');
$.CTC77 = '^[*a-zA-Z0-9]+$';
$.CTC41 = new Isolate.$isolateProperties.JSSyntaxRegExp(false, false, '^[*a-zA-Z0-9]+$');
$.CTC0 = new Isolate.$isolateProperties.NullPointerException(null, Isolate.$isolateProperties.CTC10);
$.CTC78 = 'structured clone of ArrayBufferView';
$.CTC8 = new Isolate.$isolateProperties.NotImplementedException('structured clone of ArrayBufferView');
$.Uri__COMPONENT_PATH = 5;
$.HashMapImplementation__DELETED_KEY = Isolate.$isolateProperties.CTC13;
$._BufferingSendPort__idCount = 0;
$.Uri__COMPONENT_PORT = 4;
$._lazyPort = null;
$.Uri__COMPONENT_SCHEME = 1;
$._MEASUREMENT_MESSAGE = 'DART-MEASURE';
$.LocationData__candidateHues = null;
$.GlobalId__globalId = 0;
$.Uri__splitRe = Isolate.$isolateProperties.CTC16;
$.Uri__COMPONENT_FRAGMENT = 7;
$._ReceivePortImpl__nextFreeId = 1;
$.Uri__COMPONENT_DOMAIN = 3;
$.Uri__COMPONENT_QUERY_DATA = 6;
$._getTypeNameOf = null;
$._SPAWNED_SIGNAL = 'spawned';
$._dartlibHelperRandom = null;
$._pendingMeasurementFrameCallbacks = null;
$.DualPivotQuicksort__INSERTION_SORT_THRESHOLD = 32;
$.HashMapImplementation__INITIAL_CAPACITY = 8;
$._nextMeasurementFrameScheduled = false;
$._pendingRequests = null;
$.Uri__COMPONENT_USER_INFO = 2;
$._TimerFactory__factory = null;
$._cachedBrowserPrefix = null;
$.Primitives_DOLLAR_CHAR_VALUE = 36;
$._firstMeasurementRequest = true;
var $ = null;
Isolate.$finishClasses($$);
$$ = {};
Isolate = Isolate.$finishIsolateConstructor(Isolate);
var $ = new Isolate();
$.$defineNativeClass = function(cls, fields, methods) {
  var generateGetterSetter =   function(field, prototype) {
    var len = field.length;
    var lastChar = field[len - 1];
    var needsGetter = lastChar == '?' || lastChar == '=';
    var needsSetter = lastChar == '!' || lastChar == '=';
    if (needsGetter || needsSetter) field = field.substring(0, len - 1);
    if (needsGetter) {
      var getterString = "return this." + field + ";";
        prototype["get$" + field] = new Function(getterString);
    }
    if (needsSetter) {
      var setterString = "this." + field + " = v;";
      prototype["set$" + field] = new Function("v", setterString);
    }
    return field;
  };
  for (var i = 0; i < fields.length; i++) {
    generateGetterSetter(fields[i], methods);
  }
  for (var method in methods) {
    $.dynamicFunction(method)[cls] = methods[method];
  }
};

(function(table) {
  for (var key in table) {
    $.defineProperty(Object.prototype, key, table[key]);
  }
})({
 is$JavaScriptIndexingBehavior: function() { return false; },
 is$ArrayBufferView: function() { return false; },
 is$_FileListImpl: function() { return false; },
 is$_ImageDataImpl: function() { return false; },
 is$_FileImpl: function() { return false; },
 is$_ArrayBufferViewImpl: function() { return false; },
 is$IDBKeyRange: function() { return false; },
 toString$0: function() { return $.toStringForNativeObject(this); },
 is$_BlobImpl: function() { return false; },
 is$Blob: function() { return false; },
 is$File: function() { return false; },
 is$ArrayBuffer: function() { return false; },
 is$Element: function() { return false; },
 is$List: function() { return false; },
 is$_ArrayBufferImpl: function() { return false; },
 is$Location: function() { return false; },
 is$Map: function() { return false; },
 is$FileList: function() { return false; },
 is$Collection: function() { return false; },
 is$ImageData: function() { return false; }
});

$.$defineNativeClass('AbstractWorker', [], {
 get$on: function(){  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
  {return $._AbstractWorkerEventsImpl$(this);}  } else {
    return Object.prototype.get$on.call(this);
  }
},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('HTMLAnchorElement', ["name?"], {
 toString$0: function(){return this.toString();},
 is$Element: function() { return true; }
});

$.$defineNativeClass('WebKitAnimation', ["name?"], {
});

$.$defineNativeClass('WebKitAnimationList', ["length?"], {
});

$.$defineNativeClass('HTMLAppletElement', ["height=", "name?", "width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLAreaElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('ArrayBuffer', [], {
 is$_ArrayBufferImpl: function() { return true; },
 is$ArrayBuffer: function() { return true; }
});

$.$defineNativeClass('ArrayBufferView', [], {
 is$_ArrayBufferViewImpl: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('Attr', ["name?", "value="], {
});

$.$defineNativeClass('AudioBuffer', ["length?"], {
});

$.$defineNativeClass('AudioContext', [], {
 get$on: function(){return $._AudioContextEventsImpl$(this);}
});

$.$defineNativeClass('HTMLAudioElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('AudioParam', ["name?", "value="], {
});

$.$defineNativeClass('HTMLBRElement', [], {
 clear$0: function() { return this.clear.call$0(); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLBaseElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLBaseFontElement', ["color!"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('BatteryManager', [], {
 get$on: function(){return $._BatteryManagerEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('Blob', [], {
 is$_BlobImpl: function() { return true; },
 is$Blob: function() { return true; }
});

$.$defineNativeClass('HTMLBodyElement', ["background!"], {
 get$on: function(){return $._BodyElementEventsImpl$(this);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLButtonElement', ["disabled!", "name?", "value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('CSSFontFaceRule', ["style?"], {
});

$.$defineNativeClass('WebKitCSSKeyframeRule', ["style?"], {
});

$.$defineNativeClass('WebKitCSSKeyframesRule', ["name?"], {
});

$.$defineNativeClass('WebKitCSSMatrix', ["b?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('CSSPageRule', ["style?"], {
});

$.$defineNativeClass('CSSRuleList', ["length?"], {
});

$.$defineNativeClass('CSSStyleDeclaration', ["length?"], {
 getPropertyValue$1: function(propertyName){return this.getPropertyValue(propertyName);},
 setProperty$3: function(propertyName,value,priority){return this.setProperty(propertyName,value,priority);},
 set$background: function(value){this.setProperty$3('background',value,'');},
 get$clear: function(){return this.getPropertyValue$1('clear');},
 clear$0: function() { return this.get$clear().call$0(); },
 get$clip: function(){return this.getPropertyValue$1('clip');},
 clip$0: function() { return this.get$clip().call$0(); },
 set$color: function(value){this.setProperty$3('color',value,'');},
 set$cursor: function(value){this.setProperty$3('cursor',value,'');},
 get$filter: function(){return this.getPropertyValue$1($.S($._browserPrefix())+'filter');},
 filter$1: function(arg0) { return this.get$filter().call$1(arg0); },
 set$font: function(value){this.setProperty$3('font',value,'');},
 get$height: function(){return this.getPropertyValue$1('height');},
 set$height: function(value){this.setProperty$3('height',value,'');},
 get$left: function(){return this.getPropertyValue$1('left');},
 set$textAlign: function(value){this.setProperty$3('text-align',value,'');},
 get$top: function(){return this.getPropertyValue$1('top');},
 get$transform: function(){return this.getPropertyValue$1($.S($._browserPrefix())+'transform');},
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.get$transform().call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 get$width: function(){return this.getPropertyValue$1('width');},
 set$width: function(value){this.setProperty$3('width',value,'');}
});

$.$defineNativeClass('CSSStyleRule', ["style?"], {
});

$.$defineNativeClass('CSSValueList', ["length?"], {
});

$.$defineNativeClass('HTMLCanvasElement', ["height=", "width="], {
 getContext$1: function(contextId){return this.getContext(contextId);},
 get$context2d: function(){return this.getContext$1('2d');},
 is$Element: function() { return true; }
});

$.$defineNativeClass('CanvasRenderingContext2D', ["fillStyle!", "font!", "globalAlpha!", "shadowBlur!", "shadowColor!", "shadowOffsetX!", "shadowOffsetY!", "textAlign!", "textBaseline!"], {
 beginPath$0: function(){return this.beginPath();},
 bezierCurveTo$6: function(cp1x,cp1y,cp2x,cp2y,x,y){return this.bezierCurveTo(cp1x,cp1y,cp2x,cp2y,x,y);},
 clearRect$4: function(x,y,width,height){return this.clearRect(x,y,width,height);},
 clip$0: function(){return this.clip();},
 closePath$0: function(){return this.closePath();},
 drawImage$9: function(canvas_OR_image_OR_video,sx_OR_x,sy_OR_y,sw_OR_width,height_OR_sh,dx,dy,dw,dh){return this.drawImage(canvas_OR_image_OR_video,sx_OR_x,sy_OR_y,sw_OR_width,height_OR_sh,dx,dy,dw,dh);},
 drawImage$3: function(canvas_OR_image_OR_video,sx_OR_x,sy_OR_y) {
  return this.drawImage(canvas_OR_image_OR_video,sx_OR_x,sy_OR_y);
},
 fill$0: function(){return this.fill();},
 fillText$4: function(text,x,y,maxWidth){return this.fillText(text,x,y,maxWidth);},
 fillText$3: function(text,x,y) {
  return this.fillText(text,x,y);
},
 moveTo$2: function(x,y){return this.moveTo(x,y);},
 rect$4: function(x,y,width,height){return this.rect(x,y,width,height);},
 restore$0: function(){return this.restore();},
 save$0: function(){return this.save();},
 transform$6: function(m11,m12,m21,m22,dx,dy){return this.transform(m11,m12,m21,m22,dx,dy);},
 translate$2: function(tx,ty){return this.translate(tx,ty);}
});

$.$defineNativeClass('CharacterData', ["length?"], {
});

$.$defineNativeClass('ClientRect', ["height?", "left?", "top?", "width?"], {
});

$.$defineNativeClass('ClientRectList', ["length?"], {
});

_ConsoleImpl = (typeof console == 'undefined' ? {} : console);
_ConsoleImpl.group$1 = function(arg){return this.group(arg);};
$.$defineNativeClass('HTMLContentElement', [], {
 select$1: function(arg0) { return this.select.call$1(arg0); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLDListElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('DOMApplicationCache', [], {
 get$on: function(){return $._DOMApplicationCacheEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 update$0: function(){return this.update();}
});

$.$defineNativeClass('DOMError', ["name?"], {
});

$.$defineNativeClass('DOMException', ["message?", "name?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('DOMFileSystem', ["name?"], {
});

$.$defineNativeClass('DOMFileSystemSync', ["name?"], {
});

$.$defineNativeClass('DOMMimeTypeArray', ["length?"], {
});

$.$defineNativeClass('DOMPlugin', ["length?", "name?"], {
});

$.$defineNativeClass('DOMPluginArray', ["length?"], {
});

$.$defineNativeClass('DOMSelection', [], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('DOMSettableTokenList', ["value="], {
});

$.$defineNativeClass('DOMStringList', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){throw $.$$throw($.UnsupportedOperationException$('Cannot assign element of immutable List.'));},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'String');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('DOMTokenList', ["length?"], {
 add$1: function(token){return this.add(token);},
 remove$1: function(token){return this.remove(token);},
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('HTMLDataListElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('DataTransferItemList', ["length?"], {
 add$2: function(data_OR_file,type){return this.add(data_OR_file,type);},
 add$1: function(data_OR_file) {
  return this.add(data_OR_file);
},
 clear$0: function(){return this.clear();}
});

$.$defineNativeClass('DataView', [], {
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('DedicatedWorkerContext', [], {
 get$on: function(){return $._DedicatedWorkerContextEventsImpl$(this);},
 postMessage$2: function(message,messagePorts){return this.postMessage(message,messagePorts);},
 postMessage$1: function(message) {
  return this.postMessage(message);
}
});

$.$defineNativeClass('HTMLDetailsElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLDirectoryElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLDivElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLDocument', [], {
 get$on: function(){return $._DocumentEventsImpl$(this);},
 $dom_createElement$1: function(tagName){return this.createElement(tagName);},
 $dom_getElementById$1: function(elementId){return this.getElementById(elementId);},
 $dom_getElementsByName$1: function(elementName){return this.getElementsByName(elementName);},
 $dom_getElementsByTagName$1: function(tagname){return this.getElementsByTagName(tagname);},
 $dom_querySelector$1: function(selectors){return this.querySelector(selectors);},
 $dom_querySelectorAll$1: function(selectors){return this.querySelectorAll(selectors);},
 query$1: function(selectors){if($.CTC.hasMatch$1(selectors)===true)return this.$dom_getElementById$1($.substring$1(selectors,1));return this.$dom_querySelector$1(selectors);},
 queryAll$1: function(selectors){if($.CTC40.hasMatch$1(selectors)===true){var mutableMatches=this.$dom_getElementsByName$1($.substring$2(selectors,7,selectors.length-2));if(typeof mutableMatches!=='string'&&(typeof mutableMatches!=='object'||mutableMatches===null||mutableMatches.constructor!==Array&&!mutableMatches.is$JavaScriptIndexingBehavior()))return this.queryAll$1$bailout(1,mutableMatches);var len=mutableMatches.length;var copyOfMatches=$.ListImplementation_List(len,'Element');for(var i=0;i<len;++i){if(i<0||i>=mutableMatches.length)throw $.ioore(i);var t1=mutableMatches[i];if(i<0||i>=copyOfMatches.length)throw $.ioore(i);copyOfMatches[i]=t1;}return $._FrozenElementList$_wrap(copyOfMatches);}else if($.CTC41.hasMatch$1(selectors)===true){mutableMatches=this.$dom_getElementsByTagName$1(selectors);if(typeof mutableMatches!=='string'&&(typeof mutableMatches!=='object'||mutableMatches===null||mutableMatches.constructor!==Array&&!mutableMatches.is$JavaScriptIndexingBehavior()))return this.queryAll$1$bailout(2,mutableMatches);len=mutableMatches.length;copyOfMatches=$.ListImplementation_List(len,'Element');for(i=0;i<len;++i){if(i<0||i>=mutableMatches.length)throw $.ioore(i);t1=mutableMatches[i];if(i<0||i>=copyOfMatches.length)throw $.ioore(i);copyOfMatches[i]=t1;}return $._FrozenElementList$_wrap(copyOfMatches);}else return $._FrozenElementList$_wrap(this.$dom_querySelectorAll$1(selectors));},
 queryAll$1$bailout: function(state,env0){switch(state){case 1:mutableMatches=env0;break;case 2:mutableMatches=env0;break;}switch(state){case 0:default:if(state===1||state===0&&$.CTC40.hasMatch$1(selectors)===true)switch(state){case 0:var mutableMatches=this.$dom_getElementsByName$1($.substring$2(selectors,7,selectors.length-2));case 1:state=0;var len=$.get$length(mutableMatches);var copyOfMatches=$.ListImplementation_List(len,'Element');for(var i=0;$.ltB(i,len);++i){var t1=$.index(mutableMatches,i);if(i<0||i>=copyOfMatches.length)throw $.ioore(i);copyOfMatches[i]=t1;}return $._FrozenElementList$_wrap(copyOfMatches);}else switch(state){case 0:case 2:if(state===2||state===0&&$.CTC41.hasMatch$1(selectors)===true)switch(state){case 0:mutableMatches=this.$dom_getElementsByTagName$1(selectors);case 2:state=0;len=$.get$length(mutableMatches);copyOfMatches=$.ListImplementation_List(len,'Element');for(i=0;$.ltB(i,len);++i){t1=$.index(mutableMatches,i);if(i<0||i>=copyOfMatches.length)throw $.ioore(i);copyOfMatches[i]=t1;}return $._FrozenElementList$_wrap(copyOfMatches);}else return $._FrozenElementList$_wrap(this.$dom_querySelectorAll$1(selectors));}}},
 is$Element: function() { return true; }
});

$.$defineNativeClass('DocumentFragment', [], {
 get$elements: function(){if(this._elements==null)this._elements=$.FilteredElementList$(this);return this._elements;},
 query$1: function(selectors){return this.$dom_querySelector$1(selectors);},
 queryAll$1: function(selectors){return $._FrozenElementList$_wrap(this.$dom_querySelectorAll$1(selectors));},
 set$innerHTML: function(value){  if (Object.getPrototypeOf(this).hasOwnProperty('set$innerHTML')) {
  {$.clear(this.get$nodes());var e=$._ElementFactoryProvider_Element$tag('div');e.set$innerHTML(value);var nodes=$.ListImplementation_List$from(e.get$nodes());$.addAll(this.get$nodes(),nodes);}  } else {
    return Object.prototype.set$innerHTML.call(this, value);
  }
},
 get$rect: function(){return $._createMeasurementFuture(new $._DocumentFragmentImpl_rect_anon(),$.CompleterImpl$('ElementRect'));},
 rect$4: function(arg0, arg1, arg2, arg3) { return this.get$rect().call$4(arg0, arg1, arg2, arg3); },
 get$translate: function(){return false;},
 translate$2: function(arg0, arg1) { return this.get$translate().call$2(arg0, arg1); },
 get$id: function(){return '';},
 get$$$dom_firstElementChild: function(){return this.get$elements().first$0();},
 get$$$dom_lastElementChild: function(){return $.last(this.get$elements());},
 get$parent: function(){return;},
 get$attributes: function(){return $.CTC34;},
 get$classes: function(){return $._FrozenCSSClassSet$();},
 get$dataAttributes: function(){return $.CTC34;},
 get$style: function(){return $._ElementFactoryProvider_Element$tag('div').get$style();},
 blur$0: function(){},
 get$blur: function() { return new $.BoundClosure(this, 'blur$0'); },
 click$0: function(){},
 get$click: function() { return new $.BoundClosure(this, 'click$0'); },
 set$hidden: function(value){throw $.$$throw($.UnsupportedOperationException$('Hidden can\'t be set for document fragments.'));},
 set$id: function(value){throw $.$$throw($.UnsupportedOperationException$('ID can\'t be set for document fragments.'));},
 get$on: function(){return $._ElementEventsImpl$(this);},
 $dom_querySelector$1: function(selectors){return this.querySelector(selectors);},
 $dom_querySelectorAll$1: function(selectors){return this.querySelectorAll(selectors);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('DocumentType', ["name?"], {
});

$.$defineNativeClass('Element', ["hidden!", "id=", "innerHTML!", "style?"], {
 get$attributes: function(){return $._ElementAttributeMap$(this);},
 set$elements: function(value){  if (Object.getPrototypeOf(this).hasOwnProperty('set$elements')) {
  {var elements=this.get$elements();$.clear(elements);$.addAll(elements,value);}  } else {
    return Object.prototype.set$elements.call(this, value);
  }
},
 get$elements: function(){  if (Object.getPrototypeOf(this).hasOwnProperty('get$elements')) {
  {return $._ChildrenElementList$_wrap(this);}  } else {
    return Object.prototype.get$elements.call(this);
  }
},
 query$1: function(selectors){return this.$dom_querySelector$1(selectors);},
 queryAll$1: function(selectors){return $._FrozenElementList$_wrap(this.$dom_querySelectorAll$1(selectors));},
 get$classes: function(){  if (Object.getPrototypeOf(this).hasOwnProperty('get$classes')) {
  {return $._CssClassSet$(this);}  } else {
    return Object.prototype.get$classes.call(this);
  }
},
 get$dataAttributes: function(){return $._DataAttributeMap$(this.get$attributes());},
 get$rect: function(){return $._createMeasurementFuture(new $._ElementImpl_rect_anon(this),$.CompleterImpl$('ElementRect'));},
 rect$4: function(arg0, arg1, arg2, arg3) { return this.get$rect().call$4(arg0, arg1, arg2, arg3); },
 get$on: function(){  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
  {return $._ElementEventsImpl$(this);}  } else {
    return Object.prototype.get$on.call(this);
  }
},
 get$$$dom_children: function(){return this.children;},
 translate$2: function(arg0, arg1) { return this.translate.call$2(arg0, arg1); },
 click$0: function(){return this.click();},
 get$click: function() { return new $.BoundClosure(this, 'click$0'); },
 get$$$dom_className: function(){return this.className;},
 set$$$dom_className: function(value){this.className = value;},
 get$$$dom_clientHeight: function(){return this.clientHeight;},
 get$$$dom_clientLeft: function(){return this.clientLeft;},
 get$$$dom_clientTop: function(){return this.clientTop;},
 get$$$dom_clientWidth: function(){return this.clientWidth;},
 get$$$dom_firstElementChild: function(){return this.firstElementChild;},
 get$$$dom_lastElementChild: function(){return this.lastElementChild;},
 get$$$dom_offsetHeight: function(){return this.offsetHeight;},
 get$$$dom_offsetLeft: function(){return this.offsetLeft;},
 get$$$dom_offsetTop: function(){return this.offsetTop;},
 get$$$dom_offsetWidth: function(){return this.offsetWidth;},
 get$$$dom_scrollHeight: function(){return this.scrollHeight;},
 get$$$dom_scrollLeft: function(){return this.scrollLeft;},
 get$$$dom_scrollTop: function(){return this.scrollTop;},
 get$$$dom_scrollWidth: function(){return this.scrollWidth;},
 blur$0: function(){return this.blur();},
 get$blur: function() { return new $.BoundClosure(this, 'blur$0'); },
 $dom_getAttribute$1: function(name){return this.getAttribute(name);},
 $dom_getBoundingClientRect$0: function(){return this.getBoundingClientRect();},
 $dom_getClientRects$0: function(){return this.getClientRects();},
 $dom_hasAttribute$1: function(name){return this.hasAttribute(name);},
 $dom_querySelector$1: function(selectors){return this.querySelector(selectors);},
 $dom_querySelectorAll$1: function(selectors){return this.querySelectorAll(selectors);},
 $dom_removeAttribute$1: function(name){return this.removeAttribute(name);},
 $dom_setAttribute$2: function(name,value){return this.setAttribute(name,value);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLEmbedElement', ["height=", "name?", "width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('Entry', ["name?"], {
 moveTo$4: function(parent,name,successCallback,errorCallback){return this.moveTo(parent,name,$.convertDartClosureToJS(successCallback,1),$.convertDartClosureToJS(errorCallback,1));},
 moveTo$2: function(parent$,name$) {
  return this.moveTo(parent$,name$);
},
 remove$2: function(successCallback,errorCallback){return this.remove($.convertDartClosureToJS(successCallback,0),$.convertDartClosureToJS(errorCallback,1));},
 remove$1: function(successCallback) {
  successCallback = $.convertDartClosureToJS(successCallback, 0);
  return this.remove(successCallback);
}
});

$.$defineNativeClass('EntryArray', ["length?"], {
});

$.$defineNativeClass('EntryArraySync', ["length?"], {
});

$.$defineNativeClass('EntrySync', ["name?"], {
 moveTo$2: function(parent,name){return this.moveTo(parent,name);},
 remove$0: function(){return this.remove();}
});

$.$defineNativeClass('ErrorEvent', ["message?"], {
});

$.$defineNativeClass('Event', [], {
 preventDefault$0: function(){return this.preventDefault();}
});

$.$defineNativeClass('EventException', ["message?", "name?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('EventSource', [], {
 get$on: function(){return $._EventSourceEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 close$0: function(){return this.close();},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('EventTarget', [], {
 get$on: function(){  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
  {return $._EventsImpl$(this);}  } else {
    return Object.prototype.get$on.call(this);
  }
},
 $dom_addEventListener$3: function(type,listener,useCapture){  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_addEventListener$3')) {
  {return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}  } else {
    return Object.prototype.$dom_addEventListener$3.call(this, type, listener, useCapture);
  }
},
 $dom_removeEventListener$3: function(type,listener,useCapture){  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_removeEventListener$3')) {
  {return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}  } else {
    return Object.prototype.$dom_removeEventListener$3.call(this, type, listener, useCapture);
  }
}
});

$.$defineNativeClass('HTMLFieldSetElement', ["disabled!", "elements?", "name?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('File', ["name?"], {
 is$_FileImpl: function() { return true; },
 is$File: function() { return true; },
 is$Blob: function() { return true; }
});

$.$defineNativeClass('FileException', ["message?", "name?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('FileList', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){throw $.$$throw($.UnsupportedOperationException$('Cannot assign element of immutable List.'));},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'File');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$_FileListImpl: function() { return true; },
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$FileList: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('FileReader', [], {
 get$on: function(){return $._FileReaderEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('FileWriter', ["length?"], {
 get$on: function(){return $._FileWriterEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('FileWriterSync', ["length?"], {
});

$.$defineNativeClass('Float32Array', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){this[index] = value},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'num');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('Float64Array', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){this[index] = value},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'num');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('HTMLFontElement', ["color!"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLFormElement', ["length?", "name?"], {
 reset$0: function(){return this.reset();},
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLFrameElement', ["height?", "location=", "name?", "width?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLFrameSetElement', [], {
 get$on: function(){return $._FrameSetElementEventsImpl$(this);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('Gamepad', ["id?", "index?"], {
});

$.$defineNativeClass('GamepadList', ["length?"], {
});

$.$defineNativeClass('HTMLHRElement', ["width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLAllCollection', ["length?"], {
});

$.$defineNativeClass('HTMLCollection', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){throw $.$$throw($.UnsupportedOperationException$('Cannot assign element of immutable List.'));},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'Node');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLOptionsCollection', [], {
 get$length: function(){return this.length;},
 set$length: function(value){this.length = value;},
 remove$1: function(index){return this.remove(index);},
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLHeadElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLHeadingElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('History', ["length?"], {
});

$.$defineNativeClass('HTMLHtmlElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('XMLHttpRequest', [], {
 get$on: function(){return $._HttpRequestEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 send$1: function(data){return this.send(data);}
});

$.$defineNativeClass('XMLHttpRequestException', ["message?", "name?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('XMLHttpRequestUpload', [], {
 get$on: function(){return $._HttpRequestUploadEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('IDBCursor', [], {
 get$key: function(){return $._convertNativeToDart_IDBKey(this.get$_key());},
 get$_key: function(){return this.key;}
});

$.$defineNativeClass('IDBCursorWithValue', [], {
 get$value: function(){return $._convertNativeToDart_IDBAny(this.get$_lib_value());},
 get$_lib_value: function(){return this.value;}
});

$.$defineNativeClass('IDBDatabase', ["name?"], {
 get$on: function(){return $._IDBDatabaseEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 close$0: function(){return this.close();},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('IDBDatabaseException', ["message?", "name?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('IDBIndex', ["name?"], {
});

$.$defineNativeClass('IDBKeyRange', [], {
 is$IDBKeyRange: function() { return true; }
});

$.$defineNativeClass('IDBObjectStore', ["name?"], {
 add$2: function(value,key){var t1=$===key;if(t1)key=null;if(!t1)return this._add_1$2($._convertDartToNative_SerializedScriptValue(value),key);return this._add_2$1($._convertDartToNative_SerializedScriptValue(value));},
 add$1: function(value) {
  return this.add$2(value,$)
},
 _add_1$2: function(value,key){return this.add(value,key);},
 _add_2$1: function(value){return this.add(value);},
 clear$0: function(){return this.clear();},
 index$1: function(name){return this.index(name);},
 get$index: function() { return new $.BoundClosure0(this, 'index$1'); }
});

$.$defineNativeClass('IDBOpenDBRequest', [], {
 get$on: function(){return $._IDBOpenDBRequestEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('IDBRequest', [], {
 get$on: function(){  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
  {return $._IDBRequestEventsImpl$(this);}  } else {
    return Object.prototype.get$on.call(this);
  }
},
 $dom_addEventListener$3: function(type,listener,useCapture){  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_addEventListener$3')) {
  {return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}  } else {
    return Object.prototype.$dom_addEventListener$3.call(this, type, listener, useCapture);
  }
},
 $dom_removeEventListener$3: function(type,listener,useCapture){  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_removeEventListener$3')) {
  {return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}  } else {
    return Object.prototype.$dom_removeEventListener$3.call(this, type, listener, useCapture);
  }
}
});

$.$defineNativeClass('IDBTransaction', [], {
 get$on: function(){return $._IDBTransactionEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('IDBVersionChangeRequest', [], {
 get$on: function(){return $._IDBVersionChangeRequestEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('HTMLIFrameElement', ["height=", "name?", "width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('ImageData', ["height?", "width?"], {
 is$_ImageDataImpl: function() { return true; },
 is$ImageData: function() { return true; }
});

$.$defineNativeClass('HTMLImageElement', ["height=", "name?", "width=", "x?", "y?"], {
 complete$1: function(arg0) { return this.complete.call$1(arg0); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLInputElement', ["disabled!", "height=", "name?", "value=", "width="], {
 get$on: function(){return $._InputElementEventsImpl$(this);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('Int16Array', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){this[index] = value},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'int');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('Int32Array', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){this[index] = value},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'int');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('Int8Array', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){this[index] = value},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'int');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('JavaScriptAudioNode', [], {
 get$on: function(){return $._JavaScriptAudioNodeEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('HTMLKeygenElement', ["disabled!", "name?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLLIElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLLabelElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLLegendElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLLinkElement', ["disabled!"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('LocalMediaStream', [], {
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('Location', [], {
 toString$0: function(){return this.toString();},
 is$Location: function() { return true; }
});

$.$defineNativeClass('HTMLMapElement', ["name?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLMarqueeElement', ["height=", "width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('MediaController', [], {
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('HTMLMediaElement', [], {
 get$on: function(){return $._MediaElementEventsImpl$(this);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('MediaKeyEvent', ["message?"], {
});

$.$defineNativeClass('MediaList', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){throw $.$$throw($.UnsupportedOperationException$('Cannot assign element of immutable List.'));},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'String');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('MediaQueryList', [], {
 matches$2: function(arg0, arg1) { return this.matches.call$2(arg0, arg1); }
});

$.$defineNativeClass('MediaSource', [], {
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('MediaStream', [], {
 get$on: function(){return $._MediaStreamEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_addEventListener$3')) {
  {return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}  } else {
    return Object.prototype.$dom_addEventListener$3.call(this, type, listener, useCapture);
  }
},
 $dom_removeEventListener$3: function(type,listener,useCapture){  if (Object.getPrototypeOf(this).hasOwnProperty('$dom_removeEventListener$3')) {
  {return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}  } else {
    return Object.prototype.$dom_removeEventListener$3.call(this, type, listener, useCapture);
  }
}
});

$.$defineNativeClass('MediaStreamList', ["length?"], {
});

$.$defineNativeClass('MediaStreamTrack', [], {
 get$on: function(){return $._MediaStreamTrackEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('MediaStreamTrackList', ["length?"], {
 get$on: function(){return $._MediaStreamTrackListEventsImpl$(this);},
 add$1: function(track){return this.add(track);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 remove$1: function(track){return this.remove(track);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('HTMLMenuElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('MessageEvent', ["ports?"], {
});

$.$defineNativeClass('MessagePort', [], {
 get$on: function(){return $._MessagePortEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 close$0: function(){return this.close();},
 postMessage$2: function(message,messagePorts){return this.postMessage(message,messagePorts);},
 postMessage$1: function(message) {
  return this.postMessage(message);
},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('HTMLMetaElement', ["name?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLMeterElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLModElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('MouseEvent', ["clientX?", "clientY?", "toElement?", "x?", "y?"], {
 get$offsetX: function(){if(!!this.offsetX)return this.get$_offsetX();else{var target=this.target;if(!(typeof target==='object'&&target!==null&&target.is$Element()))throw $.$$throw($.CTC29);return $.sub(this.clientX,target.$dom_getBoundingClientRect$0().get$left());}},
 get$offsetY: function(){if(!!this.offsetY)return this.get$_offsetY();else{var target=this.target;if(!(typeof target==='object'&&target!==null&&target.is$Element()))throw $.$$throw($.CTC29);return $.sub(this.clientY,target.$dom_getBoundingClientRect$0().get$top());}},
 get$_offsetX: function(){return this.offsetX},
 get$_offsetY: function(){return this.offsetY}
});

$.$defineNativeClass('NamedNodeMap', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){throw $.$$throw($.UnsupportedOperationException$('Cannot assign element of immutable List.'));},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'Node');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Navigator', ["userAgent?"], {
});

$.$defineNativeClass('Node', [], {
 get$nodes: function(){return $._ChildNodeListLazy$(this);},
 remove$0: function(){if(!(this.get$parent()==null))this.get$parent().$dom_removeChild$1(this);return this;},
 replaceWith$1: function(otherNode){try{var parent$=this.get$parent();parent$.$dom_replaceChild$2(otherNode,this);}catch(exception){$.unwrapException(exception);}return this;},
 get$$$dom_attributes: function(){return this.attributes;},
 get$$$dom_childNodes: function(){return this.childNodes;},
 get$parent: function(){  if (Object.getPrototypeOf(this).hasOwnProperty('get$parent')) {
  {return this.parentNode;}  } else {
    return Object.prototype.get$parent.call(this);
  }
},
 set$text: function(value){this.textContent = value;},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_appendChild$1: function(newChild){return this.appendChild(newChild);},
 $dom_removeChild$1: function(oldChild){return this.removeChild(oldChild);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_replaceChild$2: function(newChild,oldChild){return this.replaceChild(newChild,oldChild);}
});

$.$defineNativeClass('NodeIterator', [], {
 filter$1: function(arg0) { return this.filter.call$1(arg0); }
});

$.$defineNativeClass('NodeList', ["length?"], {
 iterator$0: function(){return $._FixedSizeListIterator$(this,'Node');},
 add$1: function(value){this._parent.$dom_appendChild$1(value);},
 addLast$1: function(value){this._parent.$dom_appendChild$1(value);},
 addAll$1: function(collection){for(var t1=$.iterator(collection),t2=this._parent;t1.hasNext$0()===true;)t2.$dom_appendChild$1(t1.next$0());},
 removeLast$0: function(){var result=this.last$0();if(!(result==null))this._parent.$dom_removeChild$1(result);return result;},
 clear$0: function(){this._parent.set$text('');},
 operator$indexSet$2: function(index,value){this._parent.$dom_replaceChild$2(value,this.operator$index$1(index));},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._NodeListWrapper$($._Collections_filter(this,[],f));},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.UnsupportedOperationException$('Cannot sort immutable List.'));},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,0)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 get$first: function(){return this.operator$index$1(0);},
 first$0: function() { return this.get$first().call$0(); },
 removeRange$2: function(start,rangeLength){throw $.$$throw($.UnsupportedOperationException$('Cannot removeRange on immutable List.'));},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.UnsupportedOperationException$('Cannot insertRange on immutable List.'));},
 getRange$2: function(start,rangeLength){return $._NodeListWrapper$($._Lists_getRange(this,start,rangeLength,[]));},
 operator$index$1: function(index){return this[index];},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Notification', [], {
 get$on: function(){return $._NotificationEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 cancel$0: function(){return this.cancel();},
 close$0: function(){return this.close();},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('HTMLOListElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLObjectElement', ["height=", "name?", "width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLOptGroupElement', ["disabled!"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLOptionElement', ["disabled!", "index?", "value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLOutputElement', ["name?", "value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLParagraphElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLParamElement', ["name?", "value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('PeerConnection00', [], {
 get$on: function(){return $._PeerConnection00EventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 close$0: function(){return this.close();},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('WebKitPoint', ["x?", "y?"], {
});

$.$defineNativeClass('PositionError', ["message?"], {
});

$.$defineNativeClass('HTMLPreElement', ["width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLProgressElement', ["value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLQuoteElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('RTCPeerConnection', [], {
 get$on: function(){return $._RTCPeerConnectionEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 close$0: function(){return this.close();},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('RadioNodeList', ["value="], {
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('Range', [], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('RangeException', ["message?", "name?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('Rect', ["left?", "top?"], {
});

$.$defineNativeClass('SQLError', ["message?"], {
});

$.$defineNativeClass('SQLException', ["message?"], {
});

$.$defineNativeClass('SQLResultSetRowList', ["length?"], {
});

$.$defineNativeClass('SVGAElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAltGlyphDefElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAltGlyphElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAltGlyphItemElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAngle', ["value="], {
});

$.$defineNativeClass('SVGAnimateColorElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAnimateElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAnimateMotionElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAnimateTransformElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGAnimationElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGCircleElement', ["r?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGClipPathElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGComponentTransferFunctionElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGCursorElement', ["x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGDefsElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGDescElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGDocument', ["rootElement?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGElement', [], {
 get$classes: function(){if(this.get$_cssClassSet()==null)this.set$_cssClassSet($._AttributeClassSet$(this.get$_ptr()));return this.get$_cssClassSet();},
 get$elements: function(){return $.FilteredElementList$(this);},
 set$elements: function(value){var elements=this.get$elements();$.clear(elements);$.addAll(elements,value);},
 set$innerHTML: function(svg){var container=$._ElementFactoryProvider_Element$tag('div');container.set$innerHTML('<svg version="1.1">'+$.S(svg)+'</svg>');this.set$elements(container.get$elements().get$first().get$elements());},
 get$id: function(){return this.id;},
 set$id: function(value){this.id = value;},
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGElementInstance', [], {
 get$on: function(){return $._SVGElementInstanceEventsImpl$(this);}
});

$.$defineNativeClass('SVGElementInstanceList', ["length?"], {
});

$.$defineNativeClass('SVGEllipseElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGException', ["message?", "name?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('SVGFEBlendElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEColorMatrixElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEComponentTransferElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFECompositeElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEConvolveMatrixElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEDiffuseLightingElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEDisplacementMapElement', ["height?", "width?", "x?", "y?"], {
 scale$1: function(arg0) { return this.scale.call$1(arg0); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEDistantLightElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEDropShadowElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFloodElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFuncAElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFuncBElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFuncGElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEFuncRElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEGaussianBlurElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEImageElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEMergeElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEMergeNodeElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEMorphologyElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEOffsetElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFEPointLightElement', ["x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFESpecularLightingElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFESpotLightElement', ["x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFETileElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFETurbulenceElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFilterElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceFormatElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceNameElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceSrcElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGFontFaceUriElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGForeignObjectElement', ["height?", "width?", "x?", "y?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGGElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGGlyphElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGGlyphRefElement', ["x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGGradientElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGHKernElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGImageElement', ["height?", "width?", "x?", "y?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGLength', ["value="], {
});

$.$defineNativeClass('SVGLengthList', [], {
 clear$0: function(){return this.clear();}
});

$.$defineNativeClass('SVGLineElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGLinearGradientElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMPathElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMarkerElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMaskElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMatrix', ["b?"], {
 scale$1: function(scaleFactor){return this.scale(scaleFactor);},
 translate$2: function(x,y){return this.translate(x,y);}
});

$.$defineNativeClass('SVGMetadataElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGMissingGlyphElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGNumber', ["value="], {
});

$.$defineNativeClass('SVGNumberList', [], {
 clear$0: function(){return this.clear();}
});

$.$defineNativeClass('SVGPathElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGPathSegArcAbs', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegArcRel', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegCurvetoCubicAbs', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegCurvetoCubicRel', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegCurvetoCubicSmoothAbs', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegCurvetoCubicSmoothRel', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegCurvetoQuadraticAbs', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegCurvetoQuadraticRel', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegCurvetoQuadraticSmoothAbs', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegCurvetoQuadraticSmoothRel', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegLinetoAbs', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegLinetoHorizontalAbs', ["x?"], {
});

$.$defineNativeClass('SVGPathSegLinetoHorizontalRel', ["x?"], {
});

$.$defineNativeClass('SVGPathSegLinetoRel', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegLinetoVerticalAbs', ["y?"], {
});

$.$defineNativeClass('SVGPathSegLinetoVerticalRel', ["y?"], {
});

$.$defineNativeClass('SVGPathSegList', [], {
 clear$0: function(){return this.clear();}
});

$.$defineNativeClass('SVGPathSegMovetoAbs', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPathSegMovetoRel', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPatternElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGPoint', ["x?", "y?"], {
});

$.$defineNativeClass('SVGPointList', [], {
 clear$0: function(){return this.clear();}
});

$.$defineNativeClass('SVGPolygonElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGPolylineElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGRadialGradientElement', ["r?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGRect', ["height=", "width=", "x?", "y?"], {
});

$.$defineNativeClass('SVGRectElement', ["height?", "width?", "x?", "y?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGSVGElement', ["height?", "width?", "x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGScriptElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGSetElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGStopElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGStringList', [], {
 clear$0: function(){return this.clear();}
});

$.$defineNativeClass('SVGStyleElement', ["disabled!"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGSwitchElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGSymbolElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTRefElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTSpanElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTextContentElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTextElement', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTextPathElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTextPositioningElement', ["x?", "y?"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTitleElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGTransformList', [], {
 clear$0: function(){return this.clear();}
});

$.$defineNativeClass('SVGUseElement', ["height?", "width?", "x?", "y?"], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); },
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGVKernElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGViewElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SVGViewSpec', [], {
 transform$6: function(arg0, arg1, arg2, arg3, arg4, arg5) { return this.transform.call$6(arg0, arg1, arg2, arg3, arg4, arg5); }
});

$.$defineNativeClass('Screen', ["height?", "width?"], {
});

$.$defineNativeClass('HTMLScriptElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLSelectElement', ["disabled!", "length=", "name?", "value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLShadowElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('ShadowRoot', ["innerHTML!"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SharedWorkerContext', ["name?"], {
 get$on: function(){return $._SharedWorkerContextEventsImpl$(this);}
});

$.$defineNativeClass('SourceBufferList', ["length?"], {
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('HTMLSourceElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLSpanElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('SpeechGrammarList', ["length?"], {
});

$.$defineNativeClass('SpeechInputResultList', ["length?"], {
});

$.$defineNativeClass('SpeechRecognition', [], {
 get$on: function(){return $._SpeechRecognitionEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('SpeechRecognitionError', ["message?"], {
});

$.$defineNativeClass('SpeechRecognitionResult', ["length?"], {
});

$.$defineNativeClass('SpeechRecognitionResultList', ["length?"], {
});

$.$defineNativeClass('Storage', [], {
 containsKey$1: function(key){return !(this.$dom_getItem$1(key)==null);},
 operator$index$1: function(key){return this.$dom_getItem$1(key);},
 operator$indexSet$2: function(key,value){return this.$dom_setItem$2(key,value);},
 putIfAbsent$2: function(key,ifAbsent){if(this.containsKey$1(key)!==true)this.operator$indexSet$2(key,ifAbsent.call$0());return this.operator$index$1(key);},
 remove$1: function(key){var value=this.operator$index$1(key);this.$dom_removeItem$1(key);return value;},
 clear$0: function(){return this.$dom_clear$0();},
 forEach$1: function(f){for(var i=0;true;++i){var key=this.$dom_key$1(i);if(key==null)return;f.call$2(key,this.operator$index$1(key));}},
 getKeys$0: function(){var keys=[];this.forEach$1(new $._StorageImpl_getKeys_anon(keys));return keys;},
 getValues$0: function(){var values=[];this.forEach$1(new $._StorageImpl_getValues_anon(values));return values;},
 get$length: function(){return this.get$$$dom_length();},
 isEmpty$0: function(){return this.$dom_key$1(0)==null;},
 get$$$dom_length: function(){return this.length;},
 $dom_clear$0: function(){return this.clear();},
 $dom_getItem$1: function(key){return this.getItem(key);},
 $dom_key$1: function(index){return this.key(index);},
 $dom_removeItem$1: function(key){return this.removeItem(key);},
 $dom_setItem$2: function(key,data){return this.setItem(key,data);},
 is$Map: function() { return true; }
});

$.$defineNativeClass('StorageEvent', ["key?"], {
});

$.$defineNativeClass('HTMLStyleElement', ["disabled!"], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('StyleSheet', ["disabled!"], {
});

$.$defineNativeClass('StyleSheetList', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){throw $.$$throw($.UnsupportedOperationException$('Cannot assign element of immutable List.'));},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'StyleSheet');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLTableCaptionElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableCellElement', ["colSpan!", "height=", "rowSpan!", "width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableColElement', ["width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableElement', ["width="], {
 insertRow$1: function(index){return this.insertRow(index);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableRowElement', [], {
 insertCell$1: function(index){return this.insertCell(index);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTableSectionElement', [], {
 insertRow$1: function(index){return this.insertRow(index);},
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLTextAreaElement', ["disabled!", "name?", "value="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('TextMetrics', ["width?"], {
});

$.$defineNativeClass('TextTrack', [], {
 get$on: function(){return $._TextTrackEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('TextTrackCue', ["id=", "text!"], {
 get$on: function(){return $._TextTrackCueEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('TextTrackCueList', ["length?"], {
});

$.$defineNativeClass('TextTrackList', ["length?"], {
 get$on: function(){return $._TextTrackListEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('TimeRanges', ["length?"], {
});

$.$defineNativeClass('HTMLTitleElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('Touch', ["clientX?", "clientY?"], {
});

$.$defineNativeClass('TouchList', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){throw $.$$throw($.UnsupportedOperationException$('Cannot assign element of immutable List.'));},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'Touch');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; }
});

$.$defineNativeClass('HTMLTrackElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('TreeWalker', [], {
 filter$1: function(arg0) { return this.filter.call$1(arg0); }
});

$.$defineNativeClass('HTMLUListElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('Uint16Array', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){this[index] = value},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'int');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('Uint32Array', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){this[index] = value},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'int');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('Uint8Array', ["length?"], {
 operator$index$1: function(index){return this[index];},
 operator$indexSet$2: function(index,value){this[index] = value},
 iterator$0: function(){return $._FixedSizeListIterator$(this,'int');},
 add$1: function(value){throw $.$$throw($.CTC1);},
 addLast$1: function(value){throw $.$$throw($.CTC1);},
 addAll$1: function(collection){throw $.$$throw($.CTC1);},
 forEach$1: function(f){return $._Collections_forEach(this,f);},
 filter$1: function(f){return $._Collections_filter(this,[],f);},
 isEmpty$0: function(){return $.eq($.get$length(this),0);},
 sort$1: function(compare){throw $.$$throw($.CTC22);},
 indexOf$2: function(element,start){return $._Lists_indexOf(this,element,start,$.get$length(this));},
 indexOf$1: function(element) {
  return this.indexOf$2(element,0)
},
 lastIndexOf$2: function(element,start){if(start==null)start=$.sub($.get$length(this),1);return $._Lists_lastIndexOf(this,element,start);},
 lastIndexOf$1: function(element) {
  return this.lastIndexOf$2(element,null)
},
 last$0: function(){return this.operator$index$1($.sub($.get$length(this),1));},
 removeLast$0: function(){throw $.$$throw($.CTC12);},
 removeRange$2: function(start,rangeLength){throw $.$$throw($.CTC17);},
 insertRange$3: function(start,rangeLength,initialValue){throw $.$$throw($.CTC20);},
 getRange$2: function(start,rangeLength){return $._Lists_getRange(this,start,rangeLength,[]);},
 is$JavaScriptIndexingBehavior: function() { return true; },
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('Uint8ClampedArray', [], {
 is$List: function() { return true; },
 is$Collection: function() { return true; },
 is$ArrayBufferView: function() { return true; }
});

$.$defineNativeClass('HTMLUnknownElement', [], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('HTMLVideoElement', ["height=", "width="], {
 is$Element: function() { return true; }
});

$.$defineNativeClass('WebGLActiveInfo', ["name?"], {
});

$.$defineNativeClass('WebKitNamedFlow', ["name?"], {
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);}
});

$.$defineNativeClass('WebSocket', [], {
 get$on: function(){return $._WebSocketEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 close$2: function(code,reason){return this.close(code,reason);},
 close$0: function() {
  return this.close();
},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 send$1: function(data){return this.send(data);}
});

$.$defineNativeClass('DOMWindow', ["length?", "name?", "navigator?"], {
 get$_top: function(){return this.top;},
 get$top: function(){return $._DOMWindowCrossFrameImpl__createSafe(this.get$_top());},
 get$location: function(){return this._get_location$0();},
 set$location: function(value){return this._set_location$1(value);},
 _get_location$0: function(){var result=this.get$_location();if($._WindowImpl__isDartLocation(result)===true)return result;if(null==this._location_wrapper)this._location_wrapper=$._LocationWrapper$(result);return this._location_wrapper;},
 _set_location$1: function(value){if(typeof value==='object'&&value!==null&&!!value.is$_LocationWrapper)this.set$_location(value._ptr);else this.set$_location(value);},
 get$_location: function(){return this.location},
 set$_location: function(value){this.location = value},
 requestAnimationFrame$1: function(callback){this._ensureRequestAnimationFrame$0();return this._requestAnimationFrame$1(callback);},
 _requestAnimationFrame$1: function(callback){return this.requestAnimationFrame($.convertDartClosureToJS(callback,1));},
 _ensureRequestAnimationFrame$0: function(){   if (this.requestAnimationFrame && this.cancelAnimationFrame) return;
   var vendors = ['ms', 'moz', 'webkit', 'o'];
   for (var i = 0; i < vendors.length && !this.requestAnimationFrame; ++i) {
     this.requestAnimationFrame = this[vendors[i] + 'RequestAnimationFrame'];
     this.cancelAnimationFrame =
         this[vendors[i]+'CancelAnimationFrame'] ||
         this[vendors[i]+'CancelRequestAnimationFrame'];
   }
   if (this.requestAnimationFrame && this.cancelAnimationFrame) return;
   this.requestAnimationFrame = function(callback) {
       return window.setTimeout(callback, 16 /* 16ms ~= 60fps */);
   };
   this.cancelAnimationFrame = function(id) { clearTimeout(id); }
},
 get$on: function(){return $._WindowEventsImpl$(this);},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 blur$0: function(){return this.blur();},
 get$blur: function() { return new $.BoundClosure(this, 'blur$0'); },
 clearInterval$1: function(handle){return this.clearInterval(handle);},
 clearTimeout$1: function(handle){return this.clearTimeout(handle);},
 close$0: function(){return this.close();},
 moveTo$2: function(x,y){return this.moveTo(x,y);},
 postMessage$3: function(message,targetOrigin,messagePorts){return this.postMessage(message,targetOrigin,messagePorts);},
 postMessage$2: function(message,targetOrigin) {
  return this.postMessage(message,targetOrigin);
},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 setInterval$2: function(handler,timeout){return this.setInterval($.convertDartClosureToJS(handler,0),timeout);},
 setTimeout$2: function(handler,timeout){return this.setTimeout($.convertDartClosureToJS(handler,0),timeout);}
});

$.$defineNativeClass('Worker', [], {
 get$on: function(){return $._WorkerEventsImpl$(this);},
 postMessage$2: function(message,messagePorts){return this.postMessage(message,messagePorts);},
 postMessage$1: function(message) {
  return this.postMessage(message);
},
 terminate$0: function(){return this.terminate();}
});

$.$defineNativeClass('WorkerContext', ["location?", "navigator?"], {
 get$on: function(){  if (Object.getPrototypeOf(this).hasOwnProperty('get$on')) {
  {return $._WorkerContextEventsImpl$(this);}  } else {
    return Object.prototype.get$on.call(this);
  }
},
 $dom_addEventListener$3: function(type,listener,useCapture){return this.addEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 clearInterval$1: function(handle){return this.clearInterval(handle);},
 clearTimeout$1: function(handle){return this.clearTimeout(handle);},
 close$0: function(){return this.close();},
 $dom_removeEventListener$3: function(type,listener,useCapture){return this.removeEventListener(type,$.convertDartClosureToJS(listener,1),useCapture);},
 setInterval$2: function(handler,timeout){return this.setInterval($.convertDartClosureToJS(handler,0),timeout);},
 setTimeout$2: function(handler,timeout){return this.setTimeout($.convertDartClosureToJS(handler,0),timeout);}
});

$.$defineNativeClass('WorkerLocation', [], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('WorkerNavigator', ["userAgent?"], {
});

$.$defineNativeClass('XPathException', ["message?", "name?"], {
 toString$0: function(){return this.toString();}
});

$.$defineNativeClass('XSLTProcessor', [], {
 reset$0: function(){return this.reset();}
});

$.$defineNativeClass('Worker', [], {
 get$id: function(){return this.id;},
 set$id: function(i){this.id = i;},
 set$onmessage: function(f){this.onmessage = f;},
 postMessage$1: function(msg){return this.postMessage(msg);}
});

$.$defineNativeClass('DOMWindow', [], {
 setTimeout$2: function(handler,timeout){return this.setTimeout($.convertDartClosureToJS(handler,0),timeout);},
 setInterval$2: function(handler,timeout){return this.setInterval($.convertDartClosureToJS(handler,0),timeout);}
});

// 345 dynamic classes.
// 395 classes
// 34 !leaf
(function(){
  var v0/*class(_SVGTextPositioningElementImpl)*/ = 'SVGTextPositioningElement|SVGTextElement|SVGTSpanElement|SVGTRefElement|SVGAltGlyphElement|SVGTextElement|SVGTSpanElement|SVGTRefElement|SVGAltGlyphElement';
  var v1/*class(_Uint8ArrayImpl)*/ = 'Uint8Array|Uint8ClampedArray|Uint8ClampedArray';
  var v2/*class(_SVGTextContentElementImpl)*/ = [v0/*class(_SVGTextPositioningElementImpl)*/,v0/*class(_SVGTextPositioningElementImpl)*/,'SVGTextContentElement|SVGTextPathElement|SVGTextPathElement'].join('|');
  var v3/*class(_SVGGradientElementImpl)*/ = 'SVGGradientElement|SVGRadialGradientElement|SVGLinearGradientElement|SVGRadialGradientElement|SVGLinearGradientElement';
  var v4/*class(_SVGComponentTransferFunctionElementImpl)*/ = 'SVGComponentTransferFunctionElement|SVGFEFuncRElement|SVGFEFuncGElement|SVGFEFuncBElement|SVGFEFuncAElement|SVGFEFuncRElement|SVGFEFuncGElement|SVGFEFuncBElement|SVGFEFuncAElement';
  var v5/*class(_SVGAnimationElementImpl)*/ = 'SVGAnimationElement|SVGSetElement|SVGAnimateTransformElement|SVGAnimateMotionElement|SVGAnimateElement|SVGAnimateColorElement|SVGSetElement|SVGAnimateTransformElement|SVGAnimateMotionElement|SVGAnimateElement|SVGAnimateColorElement';
  var v6/*class(_SVGElementImpl)*/ = [v2/*class(_SVGTextContentElementImpl)*/,v3/*class(_SVGGradientElementImpl)*/,v4/*class(_SVGComponentTransferFunctionElementImpl)*/,v5/*class(_SVGAnimationElementImpl)*/,v2/*class(_SVGTextContentElementImpl)*/,v3/*class(_SVGGradientElementImpl)*/,v4/*class(_SVGComponentTransferFunctionElementImpl)*/,v5/*class(_SVGAnimationElementImpl)*/,'SVGElement|SVGViewElement|SVGVKernElement|SVGUseElement|SVGTitleElement|SVGSymbolElement|SVGSwitchElement|SVGStyleElement|SVGStopElement|SVGScriptElement|SVGSVGElement|SVGRectElement|SVGPolylineElement|SVGPolygonElement|SVGPatternElement|SVGPathElement|SVGMissingGlyphElement|SVGMetadataElement|SVGMaskElement|SVGMarkerElement|SVGMPathElement|SVGLineElement|SVGImageElement|SVGHKernElement|SVGGlyphRefElement|SVGGlyphElement|SVGGElement|SVGForeignObjectElement|SVGFontFaceUriElement|SVGFontFaceSrcElement|SVGFontFaceNameElement|SVGFontFaceFormatElement|SVGFontFaceElement|SVGFontElement|SVGFilterElement|SVGFETurbulenceElement|SVGFETileElement|SVGFESpotLightElement|SVGFESpecularLightingElement|SVGFEPointLightElement|SVGFEOffsetElement|SVGFEMorphologyElement|SVGFEMergeNodeElement|SVGFEMergeElement|SVGFEImageElement|SVGFEGaussianBlurElement|SVGFEFloodElement|SVGFEDropShadowElement|SVGFEDistantLightElement|SVGFEDisplacementMapElement|SVGFEDiffuseLightingElement|SVGFEConvolveMatrixElement|SVGFECompositeElement|SVGFEComponentTransferElement|SVGFEColorMatrixElement|SVGFEBlendElement|SVGEllipseElement|SVGDescElement|SVGDefsElement|SVGCursorElement|SVGClipPathElement|SVGCircleElement|SVGAltGlyphItemElement|SVGAltGlyphDefElement|SVGAElement|SVGViewElement|SVGVKernElement|SVGUseElement|SVGTitleElement|SVGSymbolElement|SVGSwitchElement|SVGStyleElement|SVGStopElement|SVGScriptElement|SVGSVGElement|SVGRectElement|SVGPolylineElement|SVGPolygonElement|SVGPatternElement|SVGPathElement|SVGMissingGlyphElement|SVGMetadataElement|SVGMaskElement|SVGMarkerElement|SVGMPathElement|SVGLineElement|SVGImageElement|SVGHKernElement|SVGGlyphRefElement|SVGGlyphElement|SVGGElement|SVGForeignObjectElement|SVGFontFaceUriElement|SVGFontFaceSrcElement|SVGFontFaceNameElement|SVGFontFaceFormatElement|SVGFontFaceElement|SVGFontElement|SVGFilterElement|SVGFETurbulenceElement|SVGFETileElement|SVGFESpotLightElement|SVGFESpecularLightingElement|SVGFEPointLightElement|SVGFEOffsetElement|SVGFEMorphologyElement|SVGFEMergeNodeElement|SVGFEMergeElement|SVGFEImageElement|SVGFEGaussianBlurElement|SVGFEFloodElement|SVGFEDropShadowElement|SVGFEDistantLightElement|SVGFEDisplacementMapElement|SVGFEDiffuseLightingElement|SVGFEConvolveMatrixElement|SVGFECompositeElement|SVGFEComponentTransferElement|SVGFEColorMatrixElement|SVGFEBlendElement|SVGEllipseElement|SVGDescElement|SVGDefsElement|SVGCursorElement|SVGClipPathElement|SVGCircleElement|SVGAltGlyphItemElement|SVGAltGlyphDefElement|SVGAElement'].join('|');
  var v7/*class(_MediaElementImpl)*/ = 'HTMLMediaElement|HTMLVideoElement|HTMLAudioElement|HTMLVideoElement|HTMLAudioElement';
  var v8/*class(_MouseEventImpl)*/ = 'MouseEvent|WheelEvent|WheelEvent';
  var v9/*class(_ElementImpl)*/ = [v6/*class(_SVGElementImpl)*/,v7/*class(_MediaElementImpl)*/,v6/*class(_SVGElementImpl)*/,v7/*class(_MediaElementImpl)*/,'Element|HTMLUnknownElement|HTMLUListElement|HTMLTrackElement|HTMLTitleElement|HTMLTextAreaElement|HTMLTableSectionElement|HTMLTableRowElement|HTMLTableElement|HTMLTableColElement|HTMLTableCellElement|HTMLTableCaptionElement|HTMLStyleElement|HTMLSpanElement|HTMLSourceElement|HTMLShadowElement|HTMLSelectElement|HTMLScriptElement|HTMLQuoteElement|HTMLProgressElement|HTMLPreElement|HTMLParamElement|HTMLParagraphElement|HTMLOutputElement|HTMLOptionElement|HTMLOptGroupElement|HTMLObjectElement|HTMLOListElement|HTMLModElement|HTMLMeterElement|HTMLMetaElement|HTMLMenuElement|HTMLMarqueeElement|HTMLMapElement|HTMLLinkElement|HTMLLegendElement|HTMLLabelElement|HTMLLIElement|HTMLKeygenElement|HTMLInputElement|HTMLImageElement|HTMLIFrameElement|HTMLHtmlElement|HTMLHeadingElement|HTMLHeadElement|HTMLHRElement|HTMLFrameSetElement|HTMLFrameElement|HTMLFormElement|HTMLFontElement|HTMLFieldSetElement|HTMLEmbedElement|HTMLDivElement|HTMLDirectoryElement|HTMLDetailsElement|HTMLDataListElement|HTMLDListElement|HTMLContentElement|HTMLCanvasElement|HTMLButtonElement|HTMLBodyElement|HTMLBaseFontElement|HTMLBaseElement|HTMLBRElement|HTMLAreaElement|HTMLAppletElement|HTMLAnchorElement|HTMLElement|HTMLUnknownElement|HTMLUListElement|HTMLTrackElement|HTMLTitleElement|HTMLTextAreaElement|HTMLTableSectionElement|HTMLTableRowElement|HTMLTableElement|HTMLTableColElement|HTMLTableCellElement|HTMLTableCaptionElement|HTMLStyleElement|HTMLSpanElement|HTMLSourceElement|HTMLShadowElement|HTMLSelectElement|HTMLScriptElement|HTMLQuoteElement|HTMLProgressElement|HTMLPreElement|HTMLParamElement|HTMLParagraphElement|HTMLOutputElement|HTMLOptionElement|HTMLOptGroupElement|HTMLObjectElement|HTMLOListElement|HTMLModElement|HTMLMeterElement|HTMLMetaElement|HTMLMenuElement|HTMLMarqueeElement|HTMLMapElement|HTMLLinkElement|HTMLLegendElement|HTMLLabelElement|HTMLLIElement|HTMLKeygenElement|HTMLInputElement|HTMLImageElement|HTMLIFrameElement|HTMLHtmlElement|HTMLHeadingElement|HTMLHeadElement|HTMLHRElement|HTMLFrameSetElement|HTMLFrameElement|HTMLFormElement|HTMLFontElement|HTMLFieldSetElement|HTMLEmbedElement|HTMLDivElement|HTMLDirectoryElement|HTMLDetailsElement|HTMLDataListElement|HTMLDListElement|HTMLContentElement|HTMLCanvasElement|HTMLButtonElement|HTMLBodyElement|HTMLBaseFontElement|HTMLBaseElement|HTMLBRElement|HTMLAreaElement|HTMLAppletElement|HTMLAnchorElement|HTMLElement'].join('|');
  var v10/*class(_DocumentFragmentImpl)*/ = 'DocumentFragment|ShadowRoot|ShadowRoot';
  var v11/*class(_DocumentImpl)*/ = 'HTMLDocument|SVGDocument|SVGDocument';
  var v12/*class(_CharacterDataImpl)*/ = 'CharacterData|Text|CDATASection|CDATASection|Comment|Text|CDATASection|CDATASection|Comment';
  var v13/*class(_WorkerContextImpl)*/ = 'WorkerContext|SharedWorkerContext|DedicatedWorkerContext|SharedWorkerContext|DedicatedWorkerContext';
  var v14/*class(_NodeImpl)*/ = [v9/*class(_ElementImpl)*/,v10/*class(_DocumentFragmentImpl)*/,v11/*class(_DocumentImpl)*/,v12/*class(_CharacterDataImpl)*/,v9/*class(_ElementImpl)*/,v10/*class(_DocumentFragmentImpl)*/,v11/*class(_DocumentImpl)*/,v12/*class(_CharacterDataImpl)*/,'Node|ProcessingInstruction|Notation|EntityReference|Entity|DocumentType|Attr|ProcessingInstruction|Notation|EntityReference|Entity|DocumentType|Attr'].join('|');
  var v15/*class(_MediaStreamImpl)*/ = 'MediaStream|LocalMediaStream|LocalMediaStream';
  var v16/*class(_IDBRequestImpl)*/ = 'IDBRequest|IDBVersionChangeRequest|IDBOpenDBRequest|IDBVersionChangeRequest|IDBOpenDBRequest';
  var v17/*class(_AbstractWorkerImpl)*/ = 'AbstractWorker|Worker|SharedWorker|Worker|SharedWorker';
  var table = [
    // [dynamic-dispatch-tag, tags of classes implementing dynamic-dispatch-tag]
    ['SVGGradientElement', v3/*class(_SVGGradientElementImpl)*/],
    ['SVGTextPositioningElement', v0/*class(_SVGTextPositioningElementImpl)*/],
    ['SVGTextContentElement', v2/*class(_SVGTextContentElementImpl)*/],
    ['StyleSheet', 'StyleSheet|CSSStyleSheet|CSSStyleSheet'],
    ['AbstractWorker', v17/*class(_AbstractWorkerImpl)*/],
    ['Uint8Array', v1/*class(_Uint8ArrayImpl)*/],
    ['ArrayBufferView', [v1/*class(_Uint8ArrayImpl)*/,v1/*class(_Uint8ArrayImpl)*/,'ArrayBufferView|Uint32Array|Uint16Array|Int8Array|Int32Array|Int16Array|Float64Array|Float32Array|DataView|Uint32Array|Uint16Array|Int8Array|Int32Array|Int16Array|Float64Array|Float32Array|DataView'].join('|')],
    ['AudioParam', 'AudioParam|AudioGain|AudioGain'],
    ['Blob', 'Blob|File|File'],
    ['WorkerContext', v13/*class(_WorkerContextImpl)*/],
    ['CSSValueList', 'CSSValueList|WebKitCSSFilterValue|WebKitCSSTransformValue|WebKitCSSFilterValue|WebKitCSSTransformValue'],
    ['CharacterData', v12/*class(_CharacterDataImpl)*/],
    ['DOMTokenList', 'DOMTokenList|DOMSettableTokenList|DOMSettableTokenList'],
    ['HTMLDocument', v11/*class(_DocumentImpl)*/],
    ['DocumentFragment', v10/*class(_DocumentFragmentImpl)*/],
    ['SVGComponentTransferFunctionElement', v4/*class(_SVGComponentTransferFunctionElementImpl)*/],
    ['SVGAnimationElement', v5/*class(_SVGAnimationElementImpl)*/],
    ['SVGElement', v6/*class(_SVGElementImpl)*/],
    ['HTMLMediaElement', v7/*class(_MediaElementImpl)*/],
    ['Element', v9/*class(_ElementImpl)*/],
    ['Entry', 'Entry|FileEntry|DirectoryEntry|FileEntry|DirectoryEntry'],
    ['EntrySync', 'EntrySync|FileEntrySync|DirectoryEntrySync|FileEntrySync|DirectoryEntrySync'],
    ['MouseEvent', v8/*class(_MouseEventImpl)*/],
    ['Event', [v8/*class(_MouseEventImpl)*/,v8/*class(_MouseEventImpl)*/,v8/*class(_MouseEventImpl)*/,v8/*class(_MouseEventImpl)*/,'Event|WebGLContextEvent|UIEvent|TouchEvent|TextEvent|SVGZoomEvent|KeyboardEvent|CompositionEvent|TouchEvent|TextEvent|SVGZoomEvent|KeyboardEvent|CompositionEvent|WebKitTransitionEvent|TrackEvent|StorageEvent|SpeechRecognitionEvent|SpeechRecognitionError|SpeechInputEvent|RTCIceCandidateEvent|ProgressEvent|XMLHttpRequestProgressEvent|XMLHttpRequestProgressEvent|PopStateEvent|PageTransitionEvent|OverflowEvent|OfflineAudioCompletionEvent|MutationEvent|MessageEvent|MediaStreamTrackEvent|MediaStreamEvent|MediaKeyEvent|IDBVersionChangeEvent|IDBUpgradeNeededEvent|HashChangeEvent|ErrorEvent|DeviceOrientationEvent|DeviceMotionEvent|CustomEvent|CloseEvent|BeforeLoadEvent|AudioProcessingEvent|WebKitAnimationEvent|WebGLContextEvent|UIEvent|TouchEvent|TextEvent|SVGZoomEvent|KeyboardEvent|CompositionEvent|TouchEvent|TextEvent|SVGZoomEvent|KeyboardEvent|CompositionEvent|WebKitTransitionEvent|TrackEvent|StorageEvent|SpeechRecognitionEvent|SpeechRecognitionError|SpeechInputEvent|RTCIceCandidateEvent|ProgressEvent|XMLHttpRequestProgressEvent|XMLHttpRequestProgressEvent|PopStateEvent|PageTransitionEvent|OverflowEvent|OfflineAudioCompletionEvent|MutationEvent|MessageEvent|MediaStreamTrackEvent|MediaStreamEvent|MediaKeyEvent|IDBVersionChangeEvent|IDBUpgradeNeededEvent|HashChangeEvent|ErrorEvent|DeviceOrientationEvent|DeviceMotionEvent|CustomEvent|CloseEvent|BeforeLoadEvent|AudioProcessingEvent|WebKitAnimationEvent'].join('|')],
    ['Node', v14/*class(_NodeImpl)*/],
    ['MediaStream', v15/*class(_MediaStreamImpl)*/],
    ['IDBRequest', v16/*class(_IDBRequestImpl)*/],
    ['EventTarget', [v13/*class(_WorkerContextImpl)*/,v14/*class(_NodeImpl)*/,v15/*class(_MediaStreamImpl)*/,v16/*class(_IDBRequestImpl)*/,v17/*class(_AbstractWorkerImpl)*/,v13/*class(_WorkerContextImpl)*/,v14/*class(_NodeImpl)*/,v15/*class(_MediaStreamImpl)*/,v16/*class(_IDBRequestImpl)*/,v17/*class(_AbstractWorkerImpl)*/,'EventTarget|DOMWindow|WebSocket|WebKitNamedFlow|TextTrackList|TextTrackCue|TextTrack|SpeechRecognition|SourceBufferList|SVGElementInstance|RTCPeerConnection|Performance|PeerConnection00|Notification|MessagePort|MediaStreamTrackList|MediaStreamTrack|MediaSource|MediaController|IDBTransaction|IDBDatabase|XMLHttpRequestUpload|XMLHttpRequest|FileWriter|FileReader|EventSource|DOMApplicationCache|BatteryManager|AudioContext|DOMWindow|WebSocket|WebKitNamedFlow|TextTrackList|TextTrackCue|TextTrack|SpeechRecognition|SourceBufferList|SVGElementInstance|RTCPeerConnection|Performance|PeerConnection00|Notification|MessagePort|MediaStreamTrackList|MediaStreamTrack|MediaSource|MediaController|IDBTransaction|IDBDatabase|XMLHttpRequestUpload|XMLHttpRequest|FileWriter|FileReader|EventSource|DOMApplicationCache|BatteryManager|AudioContext'].join('|')],
    ['HTMLCollection', 'HTMLCollection|HTMLOptionsCollection|HTMLOptionsCollection'],
    ['IDBCursor', 'IDBCursor|IDBCursorWithValue|IDBCursorWithValue'],
    ['NodeList', 'NodeList|RadioNodeList|RadioNodeList']];
$.dynamicSetMetadata(table);
})();

var $globalThis = $;
var $globalState;
var $globals;
var $isWorker;
var $supportsWorkers;
var $thisScriptUrl;
function $static_init(){};

function $initGlobals(context) {
  context.isolateStatics = new Isolate();
}
function $setGlobals(context) {
  $ = context.isolateStatics;
  $globalThis = $;
}
$.main.call$0 = $.main
if (typeof document != 'undefined' && document.readyState != 'complete') {
  document.addEventListener('readystatechange', function () {
    if (document.readyState == 'complete') {
      $.startRootIsolate($.main);
    }
  }, false);
} else {
  $.startRootIsolate($.main);
}
function init() {
Isolate.$isolateProperties = {};
Isolate.$defineClass = function(cls, fields, prototype) {
  var generateGetterSetter =   function(field, prototype) {
    var len = field.length;
    var lastChar = field[len - 1];
    var needsGetter = lastChar == '?' || lastChar == '=';
    var needsSetter = lastChar == '!' || lastChar == '=';
    if (needsGetter || needsSetter) field = field.substring(0, len - 1);
    if (needsGetter) {
      var getterString = "return this." + field + ";";
        prototype["get$" + field] = new Function(getterString);
    }
    if (needsSetter) {
      var setterString = "this." + field + " = v;";
      prototype["set$" + field] = new Function("v", setterString);
    }
    return field;
  };
  var constructor;
  if (typeof fields == 'function') {
    constructor = fields;
  } else {
    var str = "function " + cls + "(";
    var body = "";
    for (var i = 0; i < fields.length; i++) {
      if (i != 0) str += ", ";
      var field = fields[i];
      field = generateGetterSetter(field, prototype);
      str += field;
      body += "this." + field + " = " + field + ";\n";
    }
    str += ") {" + body + "}\n";
    str += "return " + cls + ";";
    constructor = new Function(str)();
  }
  constructor.prototype = prototype;
  return constructor;
};
var supportsProto = false;
var tmp = Isolate.$defineClass('c', ['f?'], {}).prototype;
if (tmp.__proto__) {
  tmp.__proto__ = {};
  if (typeof tmp.get$f !== "undefined") supportsProto = true;
}
Isolate.$pendingClasses = {};
Isolate.$finishClasses = function(collectedClasses) {
  for (var cls in collectedClasses) {
    if (Object.prototype.hasOwnProperty.call(collectedClasses, cls)) {
      var desc = collectedClasses[cls];
      Isolate.$isolateProperties[cls] = Isolate.$defineClass(cls, desc[''], desc);
      if (desc['super'] !== "") Isolate.$pendingClasses[cls] = desc['super'];
    }
  }
  var pendingClasses = Isolate.$pendingClasses;
  Isolate.$pendingClasses = {};
  var finishedClasses = {};
  function finishClass(cls) {
    if (finishedClasses[cls]) return;
    finishedClasses[cls] = true;
    var superclass = pendingClasses[cls];
    if (!superclass) return;
    finishClass(superclass);
    var constructor = Isolate.$isolateProperties[cls];
    var superConstructor = Isolate.$isolateProperties[superclass];
    var prototype = constructor.prototype;
    if (supportsProto) {
      prototype.__proto__ = superConstructor.prototype;
      prototype.constructor = constructor;
    } else {
      function tmp() {};
      tmp.prototype = superConstructor.prototype;
      var newPrototype = new tmp();
      constructor.prototype = newPrototype;
      newPrototype.constructor = constructor;
      var hasOwnProperty = Object.prototype.hasOwnProperty;
      for (var member in prototype) {
        if (member == '' || member == 'super') continue;
        if (hasOwnProperty.call(prototype, member)) {
          newPrototype[member] = prototype[member];
        }
      }
    }
  }
  for (var cls in pendingClasses) finishClass(cls);
};
Isolate.$finishIsolateConstructor = function(oldIsolate) {
  var isolateProperties = oldIsolate.$isolateProperties;
  var isolatePrototype = oldIsolate.prototype;
  var str = "{\n";
  str += "var properties = Isolate.$isolateProperties;\n";
  for (var staticName in isolateProperties) {
    if (Object.prototype.hasOwnProperty.call(isolateProperties, staticName)) {
      str += "this." + staticName + "= properties." + staticName + ";\n";
    }
  }
  str += "}\n";
  var newIsolate = new Function(str);
  newIsolate.prototype = isolatePrototype;
  isolatePrototype.constructor = newIsolate;
  newIsolate.$isolateProperties = isolateProperties;
  return newIsolate;
};
}

//@ sourceMappingURL=vote_demo.dart.js.map