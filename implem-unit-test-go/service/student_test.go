package service

import (
	"errors"
	"session-9/model"
	"session-9/repository"
	"session-9/utils"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// Helper function untuk membuat service dan mock repository
func newTestService() (*StudentService, *repository.MockStudentRepository) {
	mokeRepo := new(repository.MockStudentRepository)
	service := NewStudentService(mokeRepo)
	return service, mokeRepo
}

// Test StudentService.GetAll
func TestStudentService_GetAll_Success(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
		{ID: 2, Name: "Siti", Age: 22},
	}
	svc, repo := newTestService()
	// Harapkan GetAll dipanggil dan mengembalikan initial data dan nil error
	repo.On("GetAll").Return(initial, nil).Once()

	students, err := svc.GetAll()

	assert.NoError(t, err)
	assert.Equal(t, initial, students)
	repo.AssertExpectations(t)
}

func TestStudentService_GetAll_FileError(t *testing.T) {
	svc, repo := newTestService()
	expectedErr := errors.New("simulated file read error")
	// Harapkan GetAll dipanggil dan mengembalikan empty slice dan expectedErr
	repo.On("GetAll").Return([]model.Student{}, expectedErr).Once()

	students, err := svc.GetAll()

	assert.Error(t, err)
	assert.Equal(t, expectedErr, err)
	assert.Empty(t, students)
	repo.AssertExpectations(t)
}

// Test StudentService.GetByID
func TestStudentService_GetByID_Found(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
		{ID: 2, Name: "Siti", Age: 22},
	}
	svc, repo := newTestService()
	repo.On("GetAll").Return(initial, nil).Once()

	st, err := svc.GetByID(2)

	assert.NoError(t, err)
	assert.NotNil(t, st)
	assert.Equal(t, 2, st.ID)
	assert.Equal(t, "Siti", st.Name)
	repo.AssertExpectations(t)
}

func TestStudentService_GetByID_NotFound(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
		{ID: 2, Name: "Siti", Age: 22},
	}
	svc, repo := newTestService()
	// Mengembalikan data, tetapi ID 999 tidak ada
	repo.On("GetAll").Return(initial, nil).Once()

	_, err := svc.GetByID(999)

	assert.Error(t, err)
	assert.Equal(t, utils.ErrNotFound, err)
	repo.AssertExpectations(t)
}

func TestStudentService_GetByID_GetAllError(t *testing.T) {
	svc, repo := newTestService()
	expectedErr := utils.ErrFile
	// Mengembalikan error saat GetAll
	repo.On("GetAll").Return([]model.Student{}, expectedErr).Once()

	_, err := svc.GetByID(1)

	assert.Error(t, err)
	assert.Equal(t, expectedErr, err)
	repo.AssertExpectations(t)
}

// Test StudentService.Create
func TestStudentService_Create_Success(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
	}
	input := model.Student{Name: "Budi", Age: 20}
	expectedID := 2
	svc, repo := newTestService()

	// 1. Mock GetAll untuk mendapatkan data awal
	repo.On("GetAll").Return(initial, nil).Once()
	// 2. Mock SaveAll untuk menyimpan data baru (ID 2)
	repo.On("SaveAll", mock.Anything).Return(nil).Once()

	created, err := svc.Create(input)

	assert.NoError(t, err)
	assert.Equal(t, expectedID, created.ID)
	assert.Equal(t, input.Name, created.Name)
	assert.Equal(t, input.Age, created.Age)
	repo.AssertExpectations(t)

	// Cek panggilan SaveAll dengan memastikan data yang disimpan memiliki ID yang benar
	call := repo.Calls[1] // Panggilan SaveAll adalah yang kedua (indeks 1)
	savedStudents := call.Arguments.Get(0).([]model.Student)
	assert.Equal(t, expectedID, savedStudents[len(savedStudents)-1].ID)
}

func TestStudentService_Create_EmptyInitial(t *testing.T) {
	input := model.Student{Name: "Rudi", Age: 20}
	expectedID := 1
	svc, repo := newTestService()

	// 1. Mock GetAll untuk data kosong
	repo.On("GetAll").Return([]model.Student{}, nil).Once()
	// 2. Mock SaveAll
	repo.On("SaveAll", mock.Anything).Return(nil).Once()

	created, err := svc.Create(input)

	assert.NoError(t, err)
	assert.Equal(t, expectedID, created.ID)
	repo.AssertExpectations(t)
}

func TestStudentService_Create_GetAllError(t *testing.T) {
	svc, repo := newTestService()
	input := model.Student{Name: "Budi", Age: 20}
	expectedErr := utils.ErrFile

	// Mock GetAll mengembalikan error
	repo.On("GetAll").Return([]model.Student{}, expectedErr).Once()

	_, err := svc.Create(input)

	assert.Error(t, err)
	assert.Equal(t, expectedErr, err)
	repo.AssertExpectations(t)
}

func TestStudentService_Create_SaveAllError(t *testing.T) {
	svc, repo := newTestService()
	input := model.Student{Name: "Budi", Age: 20}
	expectedErr := errors.New("simulated save error")

	// 1. Mock GetAll sukses
	repo.On("GetAll").Return([]model.Student{}, nil).Once()
	// 2. Mock SaveAll mengembalikan error
	repo.On("SaveAll", mock.Anything).Return(expectedErr).Once()

	_, err := svc.Create(input)

	assert.Error(t, err)
	assert.Equal(t, expectedErr, err)
	repo.AssertExpectations(t)
}

//  Test StudentService.Update

func TestStudentService_Update_Success(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
		{ID: 2, Name: "Siti", Age: 22},
	}
	updateID := 2
	input := model.Student{Name: "Siti Updated", Age: 25}
	svc, repo := newTestService()

	// 1. Mock GetAll sukses
	repo.On("GetAll").Return(initial, nil).Once()
	// 2. Mock SaveAll sukses
	repo.On("SaveAll", mock.Anything).Return(nil).Once()

	updated, err := svc.Update(updateID, input)

	assert.NoError(t, err)
	assert.Equal(t, updateID, updated.ID)
	assert.Equal(t, input.Name, updated.Name)
	assert.Equal(t, input.Age, updated.Age)
	repo.AssertExpectations(t)

	// Cek panggilan SaveAll untuk memastikan data telah diupdate
	call := repo.Calls[1]
	savedStudents := call.Arguments.Get(0).([]model.Student)
	assert.Equal(t, input.Name, savedStudents[1].Name) // Student dengan ID 2 berada di indeks 1
}

func TestStudentService_Update_NotFound(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
	}
	updateID := 999
	input := model.Student{Name: "NonExistent", Age: 30}
	svc, repo := newTestService()

	// 1. Mock GetAll sukses
	repo.On("GetAll").Return(initial, nil).Once()
	// SaveAll tidak boleh dipanggil

	_, err := svc.Update(updateID, input)

	assert.Error(t, err)
	assert.Equal(t, utils.ErrNotFound, err)
	repo.AssertExpectations(t)
}

func TestStudentService_Update_GetAllError(t *testing.T) {
	svc, repo := newTestService()
	updateID := 1
	input := model.Student{Name: "Budi", Age: 20}
	expectedErr := utils.ErrFile

	// Mock GetAll mengembalikan error
	repo.On("GetAll").Return([]model.Student{}, expectedErr).Once()

	_, err := svc.Update(updateID, input)

	assert.Error(t, err)
	assert.Equal(t, expectedErr, err)
	repo.AssertExpectations(t)
}

func TestStudentService_Update_SaveAllError(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
	}
	updateID := 1
	input := model.Student{Name: "Andi Updated", Age: 22}
	svc, repo := newTestService()
	expectedErr := errors.New("simulated save error")

	// 1. Mock GetAll sukses
	repo.On("GetAll").Return(initial, nil).Once()
	// 2. Mock SaveAll mengembalikan error
	repo.On("SaveAll", mock.Anything).Return(expectedErr).Once()

	_, err := svc.Update(updateID, input)

	assert.Error(t, err)
	assert.Equal(t, expectedErr, err)
	repo.AssertExpectations(t)
}

// Test StudentService.Delete
func TestStudentService_Delete_Success(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
		{ID: 2, Name: "Siti", Age: 22},
	}
	deleteID := 1
	svc, repo := newTestService()

	// 1. Mock GetAll sukses
	repo.On("GetAll").Return(initial, nil).Once()
	// 2. Mock SaveAll sukses
	repo.On("SaveAll", mock.Anything).Return(nil).Once()

	err := svc.Delete(deleteID)

	assert.NoError(t, err)
	repo.AssertExpectations(t)

	// Cek panggilan SaveAll untuk memastikan data yang disimpan hanya menyisakan student ID 2
	call := repo.Calls[1]
	savedStudents := call.Arguments.Get(0).([]model.Student)
	assert.Len(t, savedStudents, 1)
	assert.Equal(t, 2, savedStudents[0].ID)
}

func TestStudentService_Delete_NotFound(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
	}
	deleteID := 999
	svc, repo := newTestService()

	// 1. Mock GetAll sukses
	repo.On("GetAll").Return(initial, nil).Once()
	// SaveAll tidak boleh dipanggil

	err := svc.Delete(deleteID)

	assert.Error(t, err)
	assert.Equal(t, utils.ErrNotFound, err)
	repo.AssertExpectations(t)
}

func TestStudentService_Delete_GetAllError(t *testing.T) {
	svc, repo := newTestService()
	deleteID := 1
	expectedErr := utils.ErrFile

	// Mock GetAll mengembalikan error
	repo.On("GetAll").Return([]model.Student{}, expectedErr).Once()

	err := svc.Delete(deleteID)

	assert.Error(t, err)
	assert.Equal(t, expectedErr, err)
	repo.AssertExpectations(t)
}

func TestStudentService_Delete_SaveAllError(t *testing.T) {
	initial := []model.Student{
		{ID: 1, Name: "Andi", Age: 21},
	}
	deleteID := 1
	svc, repo := newTestService()
	expectedErr := errors.New("simulated save error")

	// 1. Mock GetAll sukses
	repo.On("GetAll").Return(initial, nil).Once()
	// 2. Mock SaveAll mengembalikan error
	repo.On("SaveAll", mock.Anything).Return(expectedErr).Once()

	err := svc.Delete(deleteID)

	assert.Error(t, err)
	assert.Equal(t, expectedErr, err)
	repo.AssertExpectations(t)
}
