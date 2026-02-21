package com.myallergen.backend.service.impl;

import com.myallergen.backend.dto.DrugInformationResponse;
import com.myallergen.backend.entity.Drug;
import com.myallergen.backend.repository.DrugRepository;
import com.myallergen.backend.service.DrugInformationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class DrugInformationServiceImpl implements DrugInformationService {

    private final DrugRepository drugRepository;

    @Override
    public DrugInformationResponse getDrugInformation(Integer drugId) {
        Drug drug = drugRepository.findById(drugId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Ilac bulunamadi"));

        return new DrugInformationResponse(
                drug.getId(),
                drug.getIlacAdi(),
                drug.getKisaBilgi(),
                drug.getUyariProaktifNot(),
                drug.getSureSiniri(),
                drug.getIlacBesinEtkilesimi(),
                drug.getIlacYasamTarziEtkilesimi(),
                drug.getUygulamaSekli(),
                drug.getIlacIlacCakismasi(),
                drug.getKullanimSikligi()
        );
    }
}
