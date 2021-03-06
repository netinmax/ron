package ron

import (
	"math/rand"
	"testing"
)

func TestUHeap_TakeUUID(t *testing.T) {
	var h UUIDHeap
	h.Put(ZERO_UUID)
	h.Put(ZERO_UUID)
	h.Put(NEVER_UUID)
	h.Put(NEVER_UUID)
	h.Put(NEVER_UUID)
	if h.Len() != 5 {
		t.Fail()
	}
	if h.Take() != ZERO_UUID {
		t.Fail()
	}
	if h.PopUnique() != ZERO_UUID {
		t.Fail()
	}
	if h.Len() != 3 {
		t.Fail()
	}
	if h.PopUnique() != NEVER_UUID {
		t.Fail()
	}
	if h.Len() != 0 {
		t.Fail()
	}
}

func BenchmarkUHeap_TakeUUID(b *testing.B) {
	h := MakeUHeap(false, b.N)
	for i := 0; i < b.N; i++ {
		h.Put(NewEventUUID(rand.Uint64(), 0))
	}
	b.ResetTimer()
	var bogus uint64 = 0
	for h.Len() > 0 {
		bogus++
		h.PopUnique()
	}
}
